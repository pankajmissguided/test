# MG | Test | UI Framework | Cypress

## Versions / Dependencies

```
NVM:    v0.33.8       
Node:   8.9.4        
NPM:    1.2.1         
```

__IMPORTANT:__ Whilst the the nature of cypress is to be accessible, there are some concepts that need following. I suggest reading these prior to usage:

* https://docs.cypress.io/guides/getting-started/writing-your-first-test.html
* https://docs.cypress.io/guides/core-concepts/introduction-to-cypress.html#Commands-Are-Asynchronous
* https://docs.cypress.io/guides/references/best-practices.html
* https://docs.cypress.io/guides/references/trade-offs.html


__Todo:__ See issues

__Notes:__ 
* No local evironment has been set up, so manual installation is nessasary at the moment. Docker images are available for CI from cypress.io
* Cypress feels very much like 'Testing on Rails'. Its designed to work in a specifc way and it very easy to get running. However it has drawbacks due to this in that it makes a lot of assumptions when interacting with elements, such as failing on elements with 'labels'. I recommend reading up the links above before writing any tests.


## Getting up and running

```bash
# Pre: Ensure dependancies are installed

# 1: Create new folder in desired location and move into it
$ mkdir MG-Test-UI-Framework-Cypress
$ cd MG-Test-UI-Framework

# 2: Clone the repo
$ git clone https://github.com/MissGuided/MG-Test-UI-Cypress.git

# 3: Install dependencies
$ npm install
```

## Using Docker?

```bash
# A Dockerfile has been added to the repo. However the image is not yet hosted anywhere.
# To create the image
$ docker build -t cypress_test .

# To run the container
$ docker run -i cypress_test:latest

# Get the container name
$ docker container ls

# Execute commands in docker container
$ docker exec <name> npm run cypress:run
$ docker exec <name> npm run cypress:open

```

## Commands

```bash
# Opens up the cypress app UI
$ npm run cypress:open

# Runs the tests headlessly
$ npm run cypress:run --browser electron

# See the cypress CLI page for more info

```

## Configuring for environments

__tl;dr:__
A script has been set up to simplify environment config. `env_config.sh`

Using bash, execute the script to copy the default environment config to your local machine (or CI server)

```bash
# run the script with the -e flag to set an environment:
# LOCAL
# SIT
# TEST

$ ./env_config.sh -e local
# OR
$ ./env_config.sh -e sit

# The test command will default to SIT unless a test server is specified with the -t flag

$ /env_config.sh -e test # will set sit
$ /env_config.sh -e test -t testect # will set the server to be testect

# The -t flag is a string replace so will take whatever you put in there...
```

If you still need to make changes to data for your local, you can then modify the `.cypress/fixture/*.json` files for your local. This all

__Manual setup:__ The framework uses a distributed pattern. Any localised config should not be pushed to the repo. Instead the `.sit, .local & .test` files should contain the template to allow users to fill in the required details, whilst also providing some default data. For example: `websiteUrls.json.local` contains the config required to run the framework. Simply copy and rename the `.local` file into the same location and rename it `websiteUrls.json.local` and add in the required data. `websiteUrls.json` is .gitignored, so you will not be able to commit it, but it will persist locally so you only have to set it up once. 

The following files need modifying in order to run cypress on a specific environment.

* `./cypress.json`
    * `baseUrl` needs configuring to the UK url. For example SIT would be: `"baseUrl": "https://www-sit.mgnonprod.co.uk"`
* `./cypress/fixtures/websiteUrls.json`
    * This file needs to contain all the regional URLS for your environment. See the .dist file for the lastest example
* `./cypress/fixtures/productData.json`
    * This file contains the product data required to run the framework. A product with the specified parameters needs to be supplied in this JSON. Regional URLs are only required if executing the international tests. See the .dist for the latest required data and examples.
* Anything else in the fixtures folder following this pattern.

## Tech Details

* Cypress - Self proclaiming E2E test framework. Designed to keep UI tests simple and reliable. https://www.cypress.io/

* Cypress/Mocha + Chai - Cypress uses the Mocha & Chai combination for test runner and assertion library.

## Project Structure

```bash
# All the test code lives in here
./cypress/

# New commands and supporting helpers are stored in this directory
./cypress/support/

# Page helpers are stored in here. This is where custom cypress commands
# are stored such as: cy.visitProductPage();
./cypress/support/pages/

# Storage of static data. Can be accessed by cy.fixtures('filename') command. I suggest a read up on the async nature of Cypress prior to this. An example of its use resides in the ./cypress/pages/product.js file, the cy.visitProductPage() function...
./cypress/fixtures/

# Cypress plugins
./cypress/plugins/

# Location of all test files
./cypress/integration/
```