package controller.User;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import momo.HMACUtil;
import momo.MoMoConfig;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "MoMoPaymentServlet", urlPatterns = {"/momo-payment"})
public class MoMoPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");        
        String amount = request.getParameter("totalAmount");
        System.out.println("========== SỐ TIỀN GỬI SANG MOMO: " + amount + " ==========");
        String orderInfo = "Thanh toán đơn hàng tại HA Badminton";
        String orderId = String.valueOf(System.currentTimeMillis()); 
        String requestId = String.valueOf(System.currentTimeMillis());
        
        // 1. Tạo chuỗi ký tự theo đúng chuẩn MoMo yêu cầu
        String rawSignature = "accessKey=" + MoMoConfig.ACCESS_KEY +
                "&amount=" + amount +
                "&extraData=" +
                "&ipnUrl=" + MoMoConfig.NOTIFY_URL +
                "&orderId=" + orderId +
                "&orderInfo=" + orderInfo +
                "&partnerCode=" + MoMoConfig.PARTNER_CODE +
                "&redirectUrl=" + MoMoConfig.RETURN_URL +
                "&requestId=" + requestId +
                "&requestType=captureWallet";

        try {
            // 2. Mã hóa chữ ký
            String signature = HMACUtil.HmacSHA256(rawSignature, MoMoConfig.SECRET_KEY);

            // 3. Đóng gói dữ liệu thành JSON
            JsonObject jsonRequest = new JsonObject();
            jsonRequest.addProperty("partnerCode", MoMoConfig.PARTNER_CODE);
            jsonRequest.addProperty("partnerName", "HA Badminton");
            jsonRequest.addProperty("storeId", "MomoTestStore");
            jsonRequest.addProperty("requestId", requestId);
            jsonRequest.addProperty("amount", amount);
            jsonRequest.addProperty("orderId", orderId);
            jsonRequest.addProperty("orderInfo", orderInfo);
            jsonRequest.addProperty("redirectUrl", MoMoConfig.RETURN_URL);
            jsonRequest.addProperty("ipnUrl", MoMoConfig.NOTIFY_URL);
            jsonRequest.addProperty("lang", "vi");
            jsonRequest.addProperty("extraData", "");
            jsonRequest.addProperty("requestType", "captureWallet");
            jsonRequest.addProperty("signature", signature);

            // 4. Gửi HTTP POST lên Server MoMo
            URL url = new URL(MoMoConfig.API_ENDPOINT);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            connection.setDoOutput(true);

            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = jsonRequest.toString().getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }

            // 5. Đọc phản hồi từ MoMo
            BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8));
            StringBuilder responseBuilder = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                responseBuilder.append(line);
            }
            
            // Lấy đường dẫn thanh toán và chuyển hướng người dùng
            JsonObject jsonResponse = new Gson().fromJson(responseBuilder.toString(), JsonObject.class);
            String payUrl = jsonResponse.get("payUrl").getAsString();
            
            response.sendRedirect(payUrl);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi tạo giao dịch MoMo: " + e.getMessage());
        }
    }
}