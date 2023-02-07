![[assets/print-home.png]]

## Description

This project was developed following a course on Udemy. The idea was to make an application that would help small businesses to sell their products. It is a single application with different features depending on whether the user is an administrator or not. 

It was developed using *Flutter 3.7.0* and *Dart 2.19.0*.

## Features

- Auth (using firebase)
- Edit home screen (add, edit and delete sections; grid sections or list sections; add, edit and delete images) if user is an admin
- Click on image in home screen and go to product screen
- Add, update and delete products
- Search product
- Stock logic to stop users from trying to buy products with no stock
- Different prices based on size
- Stock is managed per size
- Calculate delivery tax
- Show all orders of current user
- Show other stores, integrated with maps, telephone number and open hours
- (Admin) List of all users, when clicked opens all orders of that user
- (Admin) List of all orders, where admin can manage order status and filter orders

## Config

This project depends on an external API in order to get the address from the CEP provided. To use that API, the developer needs to go to the [CEP Aberto](https://www.cepaberto.com/) website, create an account and get their API key.

After that, a file `.env` must be created in the root directory of the application with the following structure:

```txt
CEPABERTO_KEY=YOUR_KEY
```

Comments may be inserted in the file as long as they are preceded by a #.

### Course

The [course](https://www.udemy.com/course/lojaflutter/) I studied is available on Udemy, however, it is outdated and is in Portuguese (BR).