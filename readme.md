# Apache URL Rewrite Configuration

This repository showcases the use of Apache's `mod_rewrite` module to handle URL redirection based on query string parameters. The configuration provided demonstrates how to manage redirection for URLs with specific parameters such as `language` and `country`, and create a new `locale` parameter.

## Table of Contents

- [Overview](#overview)
- [Setup](#setup)
- [Docker Setup](#docker-setup)
- [Rewrite Rules Explained](#rewrite-rules-explained)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

## Overview

The main goal of this repository is to demonstrate the capability of Apache's `mod_rewrite` module to handle complex URL rewriting scenarios. Specifically, it shows how to:
- Redirect URLs from the `/register` endpoint to the `/newuser.html` endpoint based on the presence or absence of specific query string parameters.
- Create a new `locale` parameter from `language` and `country` parameters.
- Preserve and append remaining query string parameters after redirection.


## Setup

### Prerequisites

- Apache HTTP Server installed on your system. You can download it from [Apache HTTP Server Project](https://httpd.apache.org/).
- Basic understanding of Apache configuration and `mod_rewrite`.

Rewrite Rules Explained
No language or country Parameters:

```apache
RewriteCond %{QUERY_STRING} !(^|&)language=([^&]+)(&|$)
RewriteCond %{QUERY_STRING} !(^|&)country=([^&]+)(&|$)
RewriteRule ^register$ /newuser.html?%{QUERY_STRING} [R=301,L,NE]
Redirects requests to /register without language or country parameters to /newuser.html with the original query string.
```
Only language Parameter Present:

```apache
RewriteCond %{QUERY_STRING} (^|&)language=([^&]+)(&|$)
RewriteCond %{QUERY_STRING} !(^|&)country=([^&]+)(&|$)
RewriteRule ^register$ /newuser.html?%{QUERY_STRING} [R=301,L,NE]
```
Redirects requests to /register with only the language parameter to /newuser.html with the original query string.

Only country Parameter Present:

```apache
RewriteCond %{QUERY_STRING} (^|&)country=([^&]+)(&|$)
RewriteCond %{QUERY_STRING} !(^|&)language=([^&]+)(&|$)
RewriteRule ^register$ /newuser.html?%{QUERY_STRING} [R=301,L,NE]
```

Redirects requests to /register with only the country parameter to /newuser.html with the original query string.

country First, Then language:

```apache
RewriteCond %{QUERY_STRING} (^|&)country=([^&]+)(&|.*)(&|&)language=([^&]+)(&|$)
RewriteRule ^register$ /newuser.html?locale=%5-%2&%{QUERY_STRING} [R=301,L,NE,QSD]
```
Redirects requests to /register with country first followed by language to /newuser.html and forms the locale parameter.

language First, Then country:

```apache
RewriteCond %{QUERY_STRING} (^|&)language=([^&]+)(&|.*)(&|&)country=([^&]+)(&|$)
RewriteRule ^register$ /newuser.html?locale=%2-%5&%{QUERY_STRING} [R=301,L,NE,QSD]
```

Redirects requests to /register with language first followed by country to /newuser.html and forms the locale parameter.

## End-to-End Testing

This repository includes a script for end-to-end testing named `end-2-end-test.sh`. This script automates the process of setting up Apache, running test cases, and cleaning everything up.

To run the end-to-end tests, execute the following command in your terminal:

```bash
./end-2-end-test.sh
```

This script performs the following steps:

1. Removes all Docker containers, including stopped ones.
2. Builds the Docker images as defined in the `docker-compose.yml` file.
3. Starts the Docker containers in detached mode (in the background).
4. Removes the `results.txt` file if it exists.
5. Runs the `rewrite_test.sh` script and redirects its output to `results.txt`.
6. Stops and removes the Docker containers defined in the `docker-compose.yml` file.

The results of the `rewrite_test.sh` script are saved to a file named `results.txt`. This allows you to review the test results after the script has completed.