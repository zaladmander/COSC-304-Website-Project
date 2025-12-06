# COSC-304 - GOAT Manga Website

## Mission Statement
  GOAT Manga’s mission is to provide a completely non-subjective storefront to purchase only the greatest manga. 

## Executive Summary
  GOAT Manga is a web-based retail platform created to celebrate, showcase, and shamelessly promote only the greatest manga of all time. Designed with usability, accessibility, and sheer manga addiction in mind, the system provides a streamlined shopping experience that allows users to browse titles, categorise them in search, view details about the manga, manage their shopping cart, and purchase only the greatest manga, of course. Behind the scenes, the application integrates database-driven session management and robust account handling to deliver a polished storefront.
  
  The project demonstrates the full lifecycle of a modern web application: from database schema design and data loading, to JSP-driven interfaces, responsive layouts, and user authentication. Whether a customer is returning to complete an order or an admin is viewing sales on, well, the greatest manga, GOAT Manga ensures consistent performance and a reliable website to purchase from!


## To run:

Clone the repository to your personal IDE of choice, such as VSCode, then run `docker compose up --build` from the root directory of the project (the same directory as the docker-compose.yml file is located)

Then, go to http://localhost/shop/index.jsp

You may need to load http://localhost/shop/loaddata.jsp first.

## Walkthrough:

### Creating an account:

One of the first pages you see, is the account creation page. There is a lot you need to provide... We swear, it's only for shipping you the greatest manga of all time, we follow ethics with private data!

![Creating an account](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.04.29%E2%80%AFAM.png)

![Creating an account validation](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.06.02%E2%80%AFAM.png)

![Successfully creating an account](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.06.15%E2%80%AFAM.png)

### Products page: 

The products page lists all the current manga we are selling, according to your given search query. In the case above, it’s everything. In the search bar, we will switch the category to “Horror,” and now we see results based on that. Next, let’s try looking for a specific volume, such as volume 9. As you can see in the 3rd image, the products page is showing us our specific search! Wow, so handy, huh? Next, let’s actually see some details on a product we want to purchase. We can click on the product card to go to its page.

![Products page, no query or category](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.06.27%E2%80%AFAM.png)

![Products page, categorised by Horror](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.06.47%E2%80%AFAM.png)

![Products page, categorised by Horror, with query "re"](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.06.54%E2%80%AFAM.png)

### Product detail page:

On the product page, you can find some more info, such as the product ID and a description of the book. If we decide to click on the “Add to Cart,” we will be taken to our shopping cart, and obviously, the book will be added to our cart.

![Product details](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.07.01%E2%80%AFAM.png)

### Shopping cart:

Here, the customer can see their cart, as well as make modifications if necessary, such as the quantity or outright deletion of a book from their cart. They can also check out with their customer ID and password.

![Adding the product to our cart](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.07.11%E2%80%AFAM.png)

![Modifying quantity](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.07.20%E2%80%AFAM.png)

![Added another book from the products page to cart](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.07.31%E2%80%AFAM.png)

![Deleting a product from our cart](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.07.37%E2%80%AFAM.png)

### Check out:

After adding manga to your cart, you can click the check out button to place an order on the items in your cart. You have to provide your customer id and password, where the id can be found in your account information.

![Checkout page](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.07.53%E2%80%AFAM.png)

![Order placed](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.08.00%E2%80%AFAM.png)

### Customer info:

A customer can also click on their account name in the header, which brings down a drop-down menu. From there, they can click on “Account details” to check out their personal information. They can make edits by clicking the button “Edit info.” A customer can also check their personal orders in the same dropdown menu mentioned before, by clicking “Order history.”

![Customer info page](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.40.26%E2%80%AFAM.png)

![Customer personal account information](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.09.58%E2%80%AFAM.png)

![Modifying password validation failure](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.10.05%E2%80%AFAM.png)

![Customer personal order list](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.08.13%E2%80%AFAM.png)


### Admin page:

If the user is an admin (at the time being, the only admin is admin304, as mentioned on the first page), they can access the admin dashboard through the same dropdown menu in the header. In these 3 panels, the admin can view important information in the database, and actually see graphs of orders by day, as well as sales. These are generated using chart.js.

![Main admin dashboard](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.09.25%E2%80%AFAM.png)

![Admin customer list](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.09.45%E2%80%AFAM.png)

![Admin orders list](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.09.36%E2%80%AFAM.png)

![Admin sales list](https://github.com/zaladmander/COSC-304-Website-Project/blob/main/walkthrough-images/Screenshot%202025-12-06%20at%2012.09.12%E2%80%AFAM.png)

## Resources Used
https://www.indigo.ca/en-ca/ (All book details and images for the database)

https://www.amazon.ca (For website UI loose design inspiration)

ChatGPT (For expediting development time)
- Used for the CSS design
- Storing sessional carts
- REGEX
- Quickly creating repetitive SQL statements for inserting products into the system in the DDL.
- Most responses had to be tweaked to the specifics of our codebase, or refactored to minimise code smells.

Copilot (Code reviews on GitHub)
