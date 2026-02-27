# Product Requirements Document (PRD) — PromptMint (MVP)

## 1. Product Overview
PromptMint is a web-based marketplace where users can sign up, log in, browse prompts by niche, buy prompts (simulated purchase in MVP), and sell their own prompts.

MVP focus: core marketplace workflows only (authentication, browse, buy/unlock, sell/list).

## 2. Problem Statement
Many users want high-quality AI prompts but:
- Don’t know how to write powerful prompts consistently.
- Want ready-made prompts for business, coding, and career growth.
- Lack a simple, niche-focused marketplace to buy and sell prompts.

## 3. Goals & Non-Goals
### Goals (MVP)
- Enable users to register and authenticate.
- Enable sellers to publish prompts with pricing and category.
- Enable buyers to unlock prompt content via a simulated purchase.
- Enforce access rules (content gating + no duplicate purchases).

### Non-Goals (Out of Scope for MVP)
- Real payment processing (Razorpay/Stripe/etc.)
- Ratings/reviews, comments, refunds
- Subscriptions, bundles, analytics dashboard
- Admin panel and approval workflows
- Advanced search (beyond basic category filtering)

## 4. Target Users
Primary users:
- Developers
- Freelancers
- Small business owners
- LinkedIn creators
- AI automation learners

## 5. MVP Scope (What We Will Build)
### 5.1 Authentication
Requirements:
- User signup (email + password)
- User login
- User logout
- Session-based authentication

Acceptance criteria:
- A new user can register and then log in immediately.
- Logged-out users cannot access protected actions (buy/unlock, sell, purchases list).

### 5.2 Dashboard (Marketplace)
After login, users see:
- A list of prompts
- Category filter (Automation, Coding, Career)
- A Buy button for prompts not yet purchased (and not owned)
- A View button for prompts that are purchased (or owned)

Acceptance criteria:
- Users can filter prompts by category.
- Listing clearly indicates locked vs unlocked state.

### 5.3 Categories (3 niches only)
Supported categories:
- Automation
- Coding
- Career

Constraints:
- Category is required for every prompt.
- Category is chosen from a fixed dropdown (enum).

### 5.4 Sell Prompt
Users can click “Sell Prompt” and submit a form with:
- Title (required)
- Description (required)
- Category (required; dropdown)
- Price (required; numeric)
- Full prompt content (required)

System behavior:
- On submit, a new prompt is created and becomes visible in the marketplace.
- The prompt is associated with the creator (owner).

Acceptance criteria:
- A logged-in user can create a prompt and see it in the marketplace immediately.
- Owner can view full content for their own prompt without purchasing.

### 5.5 Buy Prompt (Simulated Purchase — No Payment Gateway)
When a user clicks “Buy”:
- The system creates a Purchase record for the user + prompt.
- The system unlocks full prompt content for that user.
- The system prevents buying the same prompt twice.

Acceptance criteria:
- Buying a prompt makes its full content visible to the buyer.
- A second buy attempt for the same prompt is blocked (no duplicate purchase records).
- Non-logged users cannot buy.

### 5.6 Access Rules (Content Gating)
Rules:
- Non-logged users:
  - Can browse prompt listings (optional for MVP), but cannot buy or view full content.
- Logged-in users:
  - Can view full content only for:
    - prompts they purchased, or
    - prompts they own (created)
  - Otherwise, they see only title/description/category/price (no full prompt content).

## 6. User Stories (MVP)
- As a visitor, I can sign up so I can buy or sell prompts.
- As a user, I can log in/out to securely access my account.
- As a buyer, I can browse prompts by category to find relevant prompts.
- As a buyer, I can unlock a prompt so I can see the full content.
- As a seller, I can publish a prompt so others can buy it.
- As a user, I can see my purchased prompts in one place.

## 7. Basic Pages Required
- Landing page (optional)
- Signup
- Login
- Dashboard (marketplace listing + filters)
- Sell Prompt (create prompt form)
- Prompt Show (locked/unlocked view)
- My Purchases (list of purchased prompts)

## 8. User Flows
### 8.1 Signup Flow
User → Signup → Login → Dashboard

### 8.2 Buy Flow
Dashboard → Click Buy → Purchase Created → Redirect/Refresh → Full Prompt Visible

### 8.3 Sell Flow
Dashboard → Sell Prompt → Fill Form → Submit → Prompt Visible Publicly

## 9. Data Model (MVP)
### User
- id
- email
- password_digest
- created_at

### Prompt
- id
- title
- description
- content
- price
- category (enum: automation, coding, career)
- user_id (owner/creator)
- created_at

### Purchase
- id
- user_id
- prompt_id
- created_at

Constraints:
- purchases must be unique on (user_id, prompt_id) to prevent duplicates.

## 10. Functional Requirements Summary
- Auth: register/login/logout with sessions
- Prompt listing: browse + category filter
- Prompt creation: seller form + publish
- Purchase simulation: create purchase + unlock
- Authorization:
  - only logged-in users can buy
  - only buyers/owners can view full content
  - prevent duplicate purchases

## 11. Success Criteria (MVP Validation)
MVP is successful when:
- Users can register and log in.
- Users can upload (sell) prompts.
- Users can unlock (buy) prompts and view full content.
- The system works reliably without errors in core flows.

## 12. Future Improvements (Post-MVP)
- Razorpay integration (real payments)
- Admin approval/moderation
- Ratings & reviews
- Prompt bundles
- Subscription model
- Analytics dashboard
