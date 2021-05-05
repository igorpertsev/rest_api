# README

This application provides ability for customers to create/update/fetch contracts. Access to contracts is restricted based on customer.

# Running application

This application contains docker configuration that can be used to successfuly run it as Docker image. To do so please do following:
1) Build image on your machine. It can be done by running
  `docker-compose build`
  
2) After building application please run migrations and seeds. It can be done by runing
  `docker-compose run app rake db:migrate`
  
  This step will create all test customers and fake contracts. Also additional customer will be created for Swagger UI. For details on created users please reffer to migration files. 
  
3)  After running migrations please start docker image by running
  `docker-compose up`
  
  This step will start all required containers, namely mongo service, redis instance, sidekiq instance and actual web application. After this REST api can be found under `http://localhost:3000`
  
  Please note, that application is configured to use Docker image of mongo DB and will not work properly if it's not running. If you want to use local instance, please update configuration in `config/mongoid.yml` file.
  
# Documentation

Swagger documentation generated for this API. It can be found under `http://localhost:3000/documetation`

# Search functionality 

`GET api/contracts` endpoint also provides option to filter contracts based on passed parameters. In order to do so please add parameters to your request like this:
`
    {
      price: {
        c: 'gt',
        v: <value>
      },
      start_date: {
        c: 'lt',
        v: <value>
      },
      end_date: {
        c: 'lte',
        v: <value>
      },
      expiry_date: {
        c: 'eq',
        v: <value>
      }
    }
`

Each filter type should include 2 parameters (c for comparer and v for value). For comparer possible values are `gt`, `lt`, `gte`, `lte`, `eq`. Value should be set according expected types (Integer for price or DateTime for other fields).
