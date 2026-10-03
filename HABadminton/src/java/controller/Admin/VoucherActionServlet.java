package controller.Admin;

import dal.VoucherDAO;
import model.Voucher;
import java.io.IOException;
import java.text.SimpleDateFormat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Xử lý thao tác voucher:
 *  - add / update : submit form -> redirect về admin-vouchers
 *  - delete / toggle : gọi bằng fetch (AJAX) -> trả về "success" / "fail"
 */
@WebServlet(name = "VoucherActionServlet", urlPatterns = {"/admin-voucher-action"})
public class VoucherActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        VoucherDAO dao = new VoucherDAO();
        HttpSession session = request.getSession();

        if ("add".equals(action) || "update".equals(action)) {
            try {
                Voucher v = readVoucher(request);
                String error = validate(v);
                if (error == null && "add".equals(action) && dao.getVoucherByCode(v.getMaVoucher()) != null) {
                    error = "Mã voucher \"" + v.getMaVoucher() + "\" đã tồn tại!";
                }
                if (error == null && "update".equals(action)) {
                    Voucher old = dao.getVoucherByCode(v.getMaVoucher());
                    if (old == null) error = "Không tìm thấy voucher cần sửa!";
                    else if (v.getSoLuong() < old.getDaSuDung())
                        error = "Số lượng phát hành không được nhỏ hơn số lượt đã dùng (" + old.getDaSuDung() + ")!";
                }

                if (error != null) {
                    session.setAttribute("msgError", error);
                } else if ("add".equals(action)) {
                    if (dao.insertVoucher(v)) session.setAttribute("msgSuccess", "Đã tạo voucher " + v.getMaVoucher() + "!");
                    else session.setAttribute("msgError", "Không thể tạo voucher. Lỗi CSDL: " + dao.getLastError());
                } else {
                    if (dao.updateVoucher(v)) session.setAttribute("msgSuccess", "Đã cập nhật voucher " + v.getMaVoucher() + "!");
                    else session.setAttribute("msgError", "Cập nhật voucher thất bại. Lỗi CSDL: " + dao.getLastError());
                }
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("msgError", "Dữ liệu voucher không hợp lệ!");
            }
            response.sendRedirect("admin-vouchers");
            return;
        }

        String result = "fail";
        String code = request.getParameter("code");
        try {
            if ("delete".equals(action)) {
                if (dao.deleteVoucher(code)) result = "success";
            } else if ("toggle".equals(action)) {
                int status = Integer.parseInt(request.getParameter("status"));
                if (dao.updateStatus(code, status)) result = "success";
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().write(result);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("admin-vouchers");
    }

    private Voucher readVoucher(HttpServletRequest request) throws Exception {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        df.setLenient(false);

        Voucher v = new Voucher();
        String code = request.getParameter("maVoucher");
        v.setMaVoucher(code == null ? "" : code.trim().toUpperCase().replaceAll("\\s+", ""));
        String ten = request.getParameter("tenVoucher");
        v.setTenVoucher(ten == null ? "" : ten.trim());
        v.setLoaiGiam("1".equals(request.getParameter("loaiGiam")) ? 1 : 0);
        v.setGiaTriGiam(parseInt(request.getParameter("giaTriGiam")));
        int max = parseInt(request.getParameter("giamToiDa"));
        v.setGiamToiDa(v.getLoaiGiam() == 1 && max > 0 ? max : null);
        v.setDonToiThieu(parseInt(request.getParameter("donToiThieu")));
        v.setSoLuong(parseInt(request.getParameter("soLuong")));
        v.setNgayBatDau(df.parse(request.getParameter("ngayBatDau")));
        v.setNgayKetThuc(df.parse(request.getParameter("ngayKetThuc")));
        v.setTrangThai("1".equals(request.getParameter("trangThai")) ? 1 : 0);

        // Tự sinh tiêu đề nếu admin để trống
        if (v.getTenVoucher().isEmpty()) v.setTenVoucher(v.getMoTaGiam());
        return v;
    }

    private String validate(Voucher v) {
        if (!v.getMaVoucher().matches("[A-Z0-9_-]{3,50}"))
            return "Mã voucher chỉ gồm chữ in hoa, số, dấu - hoặc _ (3-50 ký tự)!";
        if (v.getGiaTriGiam() <= 0) return "Giá trị giảm phải lớn hơn 0!";
        if (v.getLoaiGiam() == 1 && v.getGiaTriGiam() > 100) return "Phần trăm giảm tối đa là 100%!";
        if (v.getSoLuong() <= 0) return "Số lượng phát hành phải lớn hơn 0!";
        if (v.getDonToiThieu() < 0) return "Đơn tối thiểu không hợp lệ!";
        if (v.getNgayKetThuc().before(v.getNgayBatDau())) return "Ngày kết thúc phải sau ngày bắt đầu!";
        return null;
    }

    private int parseInt(String s) {
        if (s == null) return 0;
        String digits = s.replaceAll("[^0-9]", "");
        if (digits.isEmpty()) return 0;
        if (digits.length() > 9) return Integer.MAX_VALUE;
        return Integer.parseInt(digits);
    }
}
