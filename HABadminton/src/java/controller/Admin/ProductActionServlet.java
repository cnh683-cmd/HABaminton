package controller.Admin;

import dal.SanPhamDAO;
import model.SanPham;
import java.io.File;
import java.io.IOException;
import java.text.Normalizer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 * Xử lý thao tác trên sản phẩm:
 *  - add / update : submit form (multipart, có upload ảnh) -> redirect về admin-products
 *  - delete / toggle / stock : gọi bằng fetch (AJAX) -> trả về chuỗi kết quả
 */
@WebServlet(name = "ProductActionServlet", urlPatterns = {"/admin-product-action"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024)
public class ProductActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        SanPhamDAO dao = new SanPhamDAO();
        HttpSession session = request.getSession();

        if ("add".equals(action) || "update".equals(action)) {
            String back = request.getParameter("back");
            String redirect = "admin-products" + (back != null && !back.isEmpty() ? "?" + back : "");
            try {
                SanPham sp = readProduct(request);
                String error = validate(sp);
                if (error != null) {
                    session.setAttribute("msgError", error);
                    response.sendRedirect(redirect);
                    return;
                }

                String uploaded = saveImage(request);
                if (uploaded != null) sp.setHinhAnh(uploaded);

                if ("add".equals(action)) {
                    if (sp.getHinhAnh() == null || sp.getHinhAnh().isEmpty()) sp.setHinhAnh("images/bia1.png");
                    if (dao.insertProduct(sp)) session.setAttribute("msgSuccess", "Đã thêm sản phẩm \"" + sp.getTenSP() + "\"!");
                    else session.setAttribute("msgError", "Không thể thêm sản phẩm. Hãy kiểm tra đã chạy file database/update_admin.sql chưa.");
                } else {
                    sp.setMaSP(Integer.parseInt(request.getParameter("maSP")));
                    if (sp.getHinhAnh() == null || sp.getHinhAnh().isEmpty()) {
                        SanPham old = dao.getProductFullById(sp.getMaSP());
                        if (old != null) sp.setHinhAnh(old.getHinhAnh());
                    }
                    if (dao.updateProduct(sp)) session.setAttribute("msgSuccess", "Đã cập nhật sản phẩm #" + sp.getMaSP() + "!");
                    else session.setAttribute("msgError", "Cập nhật sản phẩm thất bại!");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("msgError", "Dữ liệu số (giá, tồn kho, danh mục...) không hợp lệ!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("msgError", "Có lỗi xảy ra: " + e.getMessage());
            }
            response.sendRedirect(redirect);
            return;
        }

        // ------- Các thao tác AJAX -------
        String result = "fail";
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            if ("delete".equals(action)) {
                if (dao.deleteProduct(id)) {
                    result = "success";
                } else if (dao.updateProductStatus(id, 0)) {
                    // Sản phẩm đã có đánh giá / dữ liệu liên quan -> không xóa được, chuyển sang Ngừng bán
                    result = "hidden";
                }
            } else if ("toggle".equals(action)) {
                int status = Integer.parseInt(request.getParameter("status"));
                if (dao.updateProductStatus(id, status)) result = "success";
            } else if ("stock".equals(action)) {
                int qty = Integer.parseInt(request.getParameter("qty"));
                if (qty >= 0 && dao.updateStock(id, qty)) result = "success";
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
        response.sendRedirect("admin-products");
    }

    // ------------------------------------------------------------------ helpers

    private SanPham readProduct(HttpServletRequest request) {
        SanPham sp = new SanPham();
        sp.setTenSP(trim(request.getParameter("tenSP")));
        sp.setGiaBan(parseMoney(request.getParameter("giaBan")));
        double giaGoc = parseMoney(request.getParameter("giaGoc"));
        sp.setGiaGoc(giaGoc > 0 ? giaGoc : sp.getGiaBan());
        sp.setMaDM(Integer.parseInt(request.getParameter("maDM")));
        sp.setMaTH(Integer.parseInt(request.getParameter("maTH")));
        String sl = request.getParameter("soLuong");
        sp.setSoLuong(sl == null || sl.isEmpty() ? 0 : Integer.parseInt(sl.trim()));
        sp.setTrangThai("1".equals(request.getParameter("trangThai")) ? 1 : 0);
        sp.setSanPhamMoi(request.getParameter("sanPhamMoi") != null);
        sp.setBanChay(request.getParameter("banChay") != null);
        sp.setHinhAnh(trim(request.getParameter("hinhAnh")));
        sp.setMoTa(trim(request.getParameter("moTa")));
        sp.setXuatXu(trim(request.getParameter("xuatXu")));
        sp.setThongSo(trim(request.getParameter("thongSo")));
        return sp;
    }

    private String validate(SanPham sp) {
        if (sp.getTenSP() == null || sp.getTenSP().isEmpty()) return "Tên sản phẩm không được để trống!";
        if (sp.getGiaBan() <= 0) return "Giá bán phải lớn hơn 0!";
        if (sp.getSoLuong() < 0) return "Số lượng tồn kho không được âm!";
        return null;
    }

    /** Lưu ảnh upload vào thư mục /images của ứng dụng, trả về đường dẫn tương đối (hoặc null nếu không upload) */
    private String saveImage(HttpServletRequest request) throws IOException, ServletException {
        Part part;
        try {
            part = request.getPart("imageFile");
        } catch (Exception e) {
            return null;
        }
        if (part == null || part.getSize() == 0) return null;

        String submitted = part.getSubmittedFileName();
        if (submitted == null || submitted.isEmpty()) return null;
        String contentType = part.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new ServletException("File tải lên phải là hình ảnh!");
        }

        String ext = "";
        int dot = submitted.lastIndexOf('.');
        if (dot >= 0) ext = submitted.substring(dot).toLowerCase();
        String base = dot >= 0 ? submitted.substring(0, dot) : submitted;
        // Bỏ dấu tiếng Việt + ký tự đặc biệt để tên file an toàn
        base = Normalizer.normalize(base, Normalizer.Form.NFD).replaceAll("\\p{M}", "")
                .replace('đ', 'd').replace('Đ', 'D')
                .replaceAll("[^A-Za-z0-9_-]+", "_");
        if (base.length() > 60) base = base.substring(0, 60);
        String fileName = "sp_" + System.currentTimeMillis() + "_" + base + ext;

        String dirPath = getServletContext().getRealPath("/images");
        File dir = new File(dirPath);
        if (!dir.exists()) dir.mkdirs();
        part.write(dirPath + File.separator + fileName);
        return "images/" + fileName;
    }

    private double parseMoney(String s) {
        if (s == null) return 0;
        String digits = s.replaceAll("[^0-9]", "");
        return digits.isEmpty() ? 0 : Double.parseDouble(digits);
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }
}
