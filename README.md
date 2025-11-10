# 🧑‍💻 Mini Fiverr - Freelance Marketplace (Ruby on Rails)

Mini Fiverr is a freelance marketplace platform built with **Ruby on Rails**, inspired by Fiverr.  
It allows clients to post jobs and freelancers to offer services, communicate, and complete orders easily.

---

## 🚀 Features

✅ User authentication (Client & Freelancer)  
✅ Freelancer can create and manage gigs/services  
✅ Clients can search and order services  
✅ Messaging system (Client ↔ Freelancer chat)  
✅ Reviews and rating system  
✅ File submission after project completion  
✅ Stripe payment integration  
✅ Email notifications for order updates  

---

## 🛠️ Tech Stack

- **Backend:** Ruby on Rails  
- **Database:** PostgreSQL  
- **Frontend:** HTML, CSS, JavaScript  
- **Job Scheduler:** Sidekiq  
- **Payments:** Stripe  
- **Storage:** Active Storage (for files/images)  

---

## ⚙️ Setup Instructions

Follow these steps to set up the project on your local machine:

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/siyam-umar/mini-fiverr.git
cd mini-fiverr
2️⃣ Install Dependencies
bundle install
yarn install

3️⃣ Setup the Database
rails db:create db:migrate db:seed

4️⃣ Run the Server
rails server


Open your browser and visit:
👉 http://localhost:3000

💡 Environment Variables

Create a .env file (or use Rails credentials) and add the following:

DATABASE_URL=your_database_url
RAILS_MASTER_KEY=your_master_key
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key

🧑‍🎨 Author

Developed by: Siyam Umar
💌 Email: eishamalik979@gmail.com
