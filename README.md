# Bank-Customer-Churn-Analysis-Prediction
* **Data source: Bank Customer Churn Prediction Challenge**
* **Link:** https://www.kaggle.com/competitions/bank-customer-churn-prediction-challeng-zhenliu/data
---
## Language: [English](#-english) | [Tiếng Việt](#-tiếng-việt)
## 🇻🇳 Tiếng Việt
Dự án phân tích và dự báo nguy cơ rời bỏ dịch vụ của khách hàng ngân hàng (Customer Churn) theo quy trình: Khai phá dữ liệu với SQL trên **SQL Server**, trực quan hóa và theo dõi KPI trên **Power BI**, xây dựng mô hình phân loại dự đoán bằng **Python**, giải thích cơ chế mô hình bằng **SHAP**.

---

### 1. Tổng quan dự án
* **Bối cảnh kinh doanh:** Trong ngành tài chính - ngân hàng, chi phí để thu hút một khách hàng mới (Customer Acquisition Cost - CAC) thường cao gấp 5 đến 7 lần so với chi phí giữ chân một khách hàng hiện hữu. Khách hàng rời bỏ gây thất thoát trực tiếp đến Giá trị vòng đời khách hàng (Customer Lifetime Value - CLV).
* **Mục tiêu của dự án:**
  * Sử dụng SQL và Power BI để bóc tách các đặc trưng nhân khẩu học và hành vi tác động lớn nhất đến tỷ lệ rời bỏ (Churn Rate).
  * Machine Learning dự đoán chính xác xác suất khách hàng rời đi trên tập kiểm thử (Test set).
  * Đánh giá sự đánh đổi giữa chi phí bỏ sót khách hàng (False Negative) và chi phí chăm sóc nhầm (False Positive) để lựa chọn ngưỡng phân loại (Decision Threshold) tối ưu lợi nhuận cho ngân hàng.
### 2. Công nghệ & Thư viện sử dụng
* **Cơ sở dữ liệu & Truy vấn:** Microsoft SQL Server (T-SQL) - Phân tích nhóm (Cohort), Window Functions, Common Table Expressions (CTEs), Aggregations.
* **Business Intelligence:** Microsoft Power BI - Data Modeling, DAX Measures, Dashboard Design.
* **Data Science & Machine Learning (Python):** `pandas`, `numpy`, `scipy`, `matplotlib`, `seaborn`, `scikit-learn`, `LightGBM`, `XGBoost`.
* **Giải thích mô hình (XAI):** `SHAP`

### 3. Khám phá & Trực quan hóa Dữ liệu (SQL & Power BI Dashboard)

#### 3.1. Các chỉ số tổng quan (Executive KPIs)
* **Quy mô tệp khách hàng phân tích (Tập Train):** 15.000 khách hàng.
* **Khách hàng rời bỏ (Churned Customers):** 3.053 khách hàng, chiếm tỷ lệ **20,35%**.
* **Khách hàng duy trì (Retained Customers):** 11.947 khách hàng, chiếm tỷ lệ **79,65%**.
* **Tỷ lệ khách hàng không hoạt động (Non-active Member Rate):** Chiếm tới **50,70%** toàn bộ khách hàng.

![dashboard_bi](<power bi/dashboard_bi.png>)
> *Hình 1: Tổng quan Dashboard phân tích Customer Churn trên Power BI*

#### 3.2. Insights từ Dữ liệu
1. **Số lượng sản phẩm (`NumOfProducts`):**
   * **Điểm an toàn (2 sản phẩm):** Khách hàng dùng 2 sản phẩm có tỷ lệ churn thấp kỷ lục, chỉ **4,35%** (361 khách hàng).
   * **Nguy cơ về số lượng (1 sản phẩm):** Chiếm tới **2.478 khách hàng rời bỏ** (tỷ lệ churn **38,28%**), đóng góp tới hơn **81%** tổng số ca rời bỏ của ngân hàng.
   * **Báo động đỏ (3–4 sản phẩm):** Tỷ lệ rời bỏ rất cao (**94,23%** ở nhóm 3 sản phẩm và **100,00%** ở nhóm 4 sản phẩm), phản ánh trải nghiệm dịch vụ có thể quá phức tạp hoặc phát sinh xung đột về phí.
2. **Độ tuổi (`Age Group`):**
   * Nhóm tuổi trẻ (18–39 tuổi) rất trung thành với tỷ lệ churn chỉ từ **5,53% đến 7,94%**.
   * Nhóm tuổi 40–49 chiếm số lượng rời bỏ đông nhất (**1.449 khách**, tỷ lệ churn **36,62%**).
   * Nhóm tuổi 50–59 có tỷ lệ churn cao nhất, lên đến **74,98%**.
3. **Giới tính (`Gender`):**
   * Khách hàng nữ có tỷ lệ churn cao gần gấp 2 lần nam giới (**28,09%** so với **14,20%**) và chiếm **61,12%** tổng số lượng khách hàng rời bỏ.
4. **Khu vực địa lý (`Geography`):**
   * Thị trường **Đức (Germany)** ghi nhận tỷ lệ churn cao vượt bậc lên tới **40,07%** (1.097 khách), trong khi Pháp là **15,52%** (1.406 khách) và Tây Ban Nha là **17,18%** (550 khách).
5. **Trạng thái hoạt động (`IsActiveMember`):**
   * Khách hàng không hoạt động (Non-active) có tỷ lệ churn là **28,45%** (2.164 khách), cao hơn 2 lần nhóm tích cực (**12,02%** - 889 khách).

### 4. Xây dựng mô hình dự đoán (Machine Learning)
#### 4.1. Tiền xử lý dữ liệu
* **Loại bỏ cột không mang giá trị dự đoán:** `id`, `CustomerId`, `Surname`.
* **Mã hóa biến phân loại:** Dùng `OneHotEncoder(sparse_output=False)` cho 2 biến `Geography` và `Gender`.
* **Chuẩn hóa biến số:** Dùng `StandardScaler` cho `CreditScore`, `Age`, `Tenure`, `Balance`, `NumOfProducts`, `EstimatedSalary`.
* **Phân chia dữ liệu:** Tách tập Train (80% - 12.000 dòng) và Validation (20% - 3.000 dòng).
* **Xử lý mất cân bằng lớp:** Tính toán `class_weight='balanced'` cho Logistic Regression, Random Forest, LightGBM và tính tỷ lệ `scale_pos_weight = (y_train == 0).sum() / (y_train == 1).sum()` cho XGBoost.

![Correlation Matrix](<notebook/correlation_matrix.png>)
> *Hình 2: Ma trận tương quan giữa các đặc trưng và biến mục tiêu Exited*

#### 4.2. So sánh hiệu năng mô hình trên tập Validation (Ngưỡng mặc định 0.50)
![model evaluation](<notebook/model_evaluation.png>)
> *Hình 3: Đánh giá các chỉ số 4 mô hình ở ngưỡng 0.50*

*Mô hình LightGBM trên tập Train đạt F1 = 0.7377, sát với kết quả Validation (F1 = 0.7247), cho thấy mô hình học tốt và không bị overfitting.*

> ![Confusion Matrix 4 Models](<notebook/confusion_matrix.png>)
> *Hình 4: Ma trận nhầm lẫn (Confusion Matrix) của 4 mô hình ở ngưỡng 0.50*

### 5. Giải thích mô hình bằng SHAP (XAI)

Sử dụng `shap.TreeExplainer` trên mô hình LightGBM để bóc tách tính năng:

![SHAP Feature Importance](<notebook/mean_shap_value.png>)
> *Hình 5: Mức độ quan trọng trung bình của các đặc trưng (SHAP Feature Importance)*

1. **Xếp hạng độ quan trọng (Feature Importance - Bar Plot):**
   * **`NumOfProducts`** và **`Age`** là hai biến có tầm ảnh hưởng lớn nhất áp đảo đến kết quả dự đoán rời bỏ của mô hình.
   * Tiếp theo là **`IsActiveMember`**, **`Gender_Female`** và **`Geography_Germany`**

![SHAP Summary Beeswarm Plot](<notebook/shap_value.png>)
> *Hình 6: Chiều hướng và mức độ tác động của từng đặc trưng lên dự đoán (SHAP Summary Plot)*

2. **Chiều tác động đặc trưng (Summary Plot - Beeswarm Plot):**
   * **`NumOfProducts`:** Khách hàng sử dụng 2 sản phẩm có giá trị SHAP âm rõ rệt (giảm mạnh xác suất churn). Ngược lại, chỉ dùng 1 sản phẩm đẩy SHAP value sang dương (tăng nguy cơ churn).
   * **`Age`:** Khách hàng lớn tuổi (điểm đỏ) kéo dạt sang bên phải (SHAP value > 3), là nhân tố thúc đẩy churn mạnh nhất về nhân khẩu học.
   * **`IsActiveMember`:** Là hội viên tích cực (`Active = 1`) kéo giảm mạnh nguy cơ rời bỏ.
   * **`Gender_Female` & `Geography_Germany`:** Khách hàng nữ và khách hàng tại Đức có xu hướng làm tăng xác suất churn.

### 6. Đánh giá

#### 6.1. Lựa chọn thuật toán cốt lõi
Dự án chọn **LightGBM** thay vì XGBoost. Dù cả hai có AUC-ROC xấp xỉ tương đương (~0.936), LightGBM tối ưu hơn hẳn về tốc độ huấn luyện và tài nguyên bộ nhớ (nhờ thuật toán Histogram-based), rất phù hợp để triển khai trên các hệ thống cơ sở dữ liệu lớn của ngân hàng.

![ROC Curve](<notebook/roc_curve.png>)
> *Hình 7: Đường cong ROC của các mô hình phân loại*

#### 6.2. Phân tích bài toán đánh đổi chi phí (Cost-Benefit Trade-off)
* **Ngưỡng tối ưu toán học (Threshold = 0.62):**
  * Đạt F1-score = 0.7486 cao nhất.
  * Ma trận nhầm lẫn: TN = 2215, FP = 174, FN = 142, TP = 469.
* **Ngưỡng vận hành thực tế đề xuất (Threshold = 0.50):**
  * Ma trận nhầm lẫn: TN = 2099, FP = 290, FN = 99, TP = 512.

![Confusion Matrix Comparison](<notebook/confusion_matrix_lgb_xgb.png>)
> *Hình 8: So sánh phân bổ ma trận nhầm lẫn ở các mốc ngưỡng phân loại*

* **Lý do lựa chọn ngưỡng 0.50 thay vì 0.62:**
  * Trong nghiệp vụ ngân hàng, chi phí bỏ sót một khách hàng thực sự rời đi (False Negative - mất vĩnh viễn CLV và tốn chi phí CAC để bù đắp) lớn hơn gấp nhiều lần chi phí chăm sóc/tặng ưu đãi nhầm cho một khách hàng ở lại (False Positive).
  * Khi hạ ngưỡng xuống 0.50, số lượng bỏ sót giảm mạnh từ 142 ca xuống còn 99 ca, giúp ngân hàng giữ chân thêm được 43 khách hàng thực sự sắp rời bỏ.

### 7. Khuyến nghị
* Tập trung chuyển đổi tệp khách hàng đang chỉ sử dụng 1 sản phẩm sang sản phẩm thứ 2 nhằm giảm tỷ lệ churn từ 38,28% xuống 4,35%.
* Rà soát lại biểu phí và chính sách cho nhóm khách hàng sở hữu 3–4 sản phẩm để tìm nguyên nhân khiến tỷ lệ rời bỏ chạm mốc 94%–100%.
* Chương trình giữ chân khách hàng cho thị trường Đức để giải quyết tỷ lệ churn báo động 40,07%).
* Gửi thông báo ưu đãi khi tài khoản không phát sinh giao dịch trong 30–45 ngày để ngăn khách hàng chuyển từ Active sang Non-active nhằm giảm thiểu tỷ lệ churn 28,45%).

### 8. Cấu trúc thư mục dự án

```text
├── sql/
│   ├── 1_data_cleaning.sql
│   ├── 2_churn_analysis.sql
│   └── 3_create_view.sql           # Script truy vấn
├── power bi/
│   ├── dashboard_bi.pbix           # Báo cáo dashboard phân tích trên Power BI
│   ├── dashboard_bi.pdf               
│   └── dashboard_bi.png            # Ảnh chụp giao diện dashboard                           
├── notebooks/
│   ├── data_prediction.ipynb       # Dự đoán khách hàng trên Python qua các mô hình học máy
│   ├── bank_churn_prediction.csv   # Xác suất rời bỏ dự đoán trên tập test
│   ├── correlation_matrix.png
│   ├── confusion_matrix.png
│   ├── confusion_matrix_lgb_xgb.png
│   ├── mean_shap_value.png
│   ├── shap_value.png
│   ├── roc_curve.png
│   └── model_evalution.png
├── LICENSE         
└── README.md                        # Tài liệu tổng quan dự án
```
