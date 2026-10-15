# 📊 Customer Sales & Revenue Data Analysis Project

## 📌 Overview
Project hii inafanya uchambuzi wa kina wa takwimu za mauzo na wateja (*Customer Sales & Revenue Data Analysis*) kwa kutumia **SQL Server**. Lengo kuu ni kuchunguza tabia za wateja, kiwango cha mapato (revenue), mchango wa bidhaa, mwenendo wa mauzo kwa miezi, na viwango vya kubaki kwa wateja (*Customer Cohort & Retention Analysis*).

---

## 🛠️ Key SQL Techniques & Concepts Used
Uchambuzi huu unatumia vipengele vya juu vya SQL, ikiwa ni pamoja na:
* **Data Cleaning & Validation:** Kuhakiki ukubwa wa data, kutafuta maadili yaliyopotea (*NULL values*), na kuangalia *duplicates*.
* **Aggregations & Grouping:** Kuchambua mapato kwa makundi ya bidhaa (*product categories*) na maeneo (*regions*).
* **Window Functions:** Kutumia `LAG()`, `ROW_NUMBER()`, na `DENSE_RANK()` kwa ajili ya kulinganisha miezi na kuweka viwango (ranking).
* **Common Table Expressions (CTEs):** Kuandika miundo ya muda (*temporary result sets*) kurahisisha uchambuzi tanzu.
* **Cohort & Retention Analysis:** Kupima uwezo wa kampuni kuwahifadhi wateja (*Customer Retention Rate*) na kiwango cha wateja wanaoondoka (*Churn Rate*) kwa miezi.

---

## 📂 Dataset Structure (`CUSTOMER_SALE_TABLE`)
Safu kuu zinazopatikana kwenye jedwali hili ni pamoja na:
* `order_id` - Kitambulisho cha oda
* `customer_id` - Kitambulisho cha mteja
* `order_date` - Tarehe ya oda kufanyika
* `product_category` - Aina ya bidhaa
* `region` - Eneo la mauzo
* `quantity` - Idadi ya bidhaa zilizouzwa
* `unit_price` - Bei ya bidhaa moja
* `revenue` - Mapato yaliyopatikana

---

## 📈 Key Insights & Findings
1. **Regional Performance:** Maeneo ya Kusini na Kaskazini yanaongoza kwa uzalishaji wa mapato ikilinganishwa na maeneo mengine kutokana na idadi kubwa ya bidhaa zinazouzwa.
2. **Revenue Growth Trends:** Uchambuzi wa mwezi kwa mwezi unaonyesha mabadiliko chanya ya mapato kwenye miezi kama vile Aprili na Julai, wakati miezi mingine ikihitaji mikakati ya kuongeza nguvu kazi.
3. **Customer Retention:** Kiwango cha wateja kurudi kunatofautiana kulingana na mwezi, ikionyesha umuhimu wa kuboresha ubora wa bidhaa ili kuongeza kiwango cha wateja wanaobaki (*retention rate*).

---
