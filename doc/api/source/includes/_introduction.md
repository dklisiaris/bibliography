# Introduction

The __Bibliography API__ is a book _metadata service_ for books published in greek language and a social data provider. Metadata is the information (data) which describes other information (in this case: books). Currently all metadata are being extracted from [biblionet.gr](http://biblionet.gr). 

You can search for a specific book by providing its _isbn_ or its _biblionet id_. You can also perform more _advanced searches_ by providing book's title, author, publishing date etc. and receive a collection of books. Beyond books, information about authors and publishers are available too. 

All __requests__ are done through _http_, so you build your url depending on what you want to search for and do the request. Currently all __responses__ are in _json_ format and you can choose pretty or minified json. 
     
## Audience

This document is intended for website and mobile developers who want to use the bibliography API in order to collect and present information about greek books or build a front-end client or mobile app for [bibliography.gr](http://bibliography.gr). 
It provides a guide to using the API and reference material on the available parameters.