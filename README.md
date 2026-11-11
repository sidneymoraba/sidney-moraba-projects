# Sidney Moraba: Starter Projects

Three small projects for my portfolio. Each lives in its own folder.

| Project | What it does | Tech |
|---|---|---|
| `money-manager` | Plan a month after salary: expenses, categories, savings goal and a safe daily spend | HTML, CSS, JavaScript |
| `task-tracker` | Track project tasks across To do, In progress and Done | HTML, CSS, JavaScript |
| `coffee-shop-database` | Relational database for a coffee shop: customers, products, orders, payments | MySQL 8 |

## Run the web apps
Open `index.html` in a browser, or publish the repository with GitHub Pages. Data is saved in the browser (localStorage).

## Run the database
```
mysql -u root -p < coffee-shop-database/schema.sql
mysql -u root -p < coffee-shop-database/seed.sql
mysql -u root -p < coffee-shop-database/queries.sql
```
