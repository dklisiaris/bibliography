# Books

## Get a book

```shell
# These commands extract the same book.
curl "http://bookshark.eu/api/v1/book?isbn=960-14-1157-7"
curl "http://bookshark.eu/api/v1/book?id=103788"
curl "http://bookshark.eu/api/v1/book?uri=http://biblionet.gr/book/103788/"

```

> The above commands return JSON structured like this:

```json
{
  "book": [
    {
      "title": "Σημεία και τέρατα της οικονομίας",
      "subtitle": "Η κρυφή πλευρά των πάντων",
      "image": "http://www.biblionet.gr/images/covers/b103788.jpg",
      "author": [
        {
          "name": "Steven D. Levitt",
          "b_id": "59782"
        },
        {
          "name": "Stephen J. Dubner",
          "b_id": "59783"
        }
      ],
      "contributors": {
        "μετάφραση": [
          {
            "name": "Άγγελος Φιλιππάτος",
            "b_id": "851"
          }
        ]
      },
      "publisher": {
        "text": "Εκδοτικός Οίκος Α. Α. Λιβάνη",
        "b_id": "271"
      },
      "isbn": "960-14-1157-7",
      "isbn_13": "978-960-14-1157-6",
      "award": [
      ],
      "description": "Τι είναι πιο επικίνδυνο, ένα όπλο ή μια πισίνα; Τι κοινό έχουν οι δάσκαλοι με τους παλαιστές του σούμο;...",
      "category": [
        {
          "ddc": "330",
          "name": "Οικονομία",
          "b_id": "142"
        }
      ],
      "b_id": "103788",
      "publication": {
        "year": "2006",
        "version": "1",
        "place": "Αθήνα"
      },
      "format": "Βιβλίο",
      "original_language": "αγγλικά",
      "original_title": "Freakonomics",
      "price": "16,31",
      "availability": "Κυκλοφορεί",
      "last_update": "27/1/2006",
      "series": {
        "name": "Οικονομία",
        "volume": null
      },
      "physical_description": {
        "pages": "326",
        "size": "21x14",
        "cover_type": "Μαλακό εξώφυλλο"
      }
    }
  ]
}
```

This endpoint retrieves a specific book, based on its isbn, its biblionet id or url.

### HTTP Request

`GET http://bookshark.eu/api/v1/book?parameters`

### Query Parameters

In each request only one of isbn, id and uri should be used to specify the book.

Parameter | Default | Description
--------- | ------- | -----------
isbn | empty | The book's ISBN code.
id | empty | The book's id in biblionet site.
uri | empty | The book's url in biblionet site.
eager | 0 | If set to 1, it activates eager book extraction.

### Some example requests

Generally the preferable option is getting books by isbn. If the biblionet id is known then thats the fastest method. Here are some request examples which fetch the same book:

`GET http://bookshark.eu/api/v1/book?isbn=960-14-1157-7`

`GET http://bookshark.eu/api/v1/book?id=103788`

`GET http://bookshark.eu/api/v1/book?uri=http://biblionet.gr/book/103788/`

`GET http://bookshark.eu/api/v1/book?isbn=978-960-14-1157-6`

`GET http://bookshark.eu/api/v1/book?isbn=9789601411576`


<aside class="success">
Remember — ISBN can contain dashes or be a plain number. ISBN-13 is also acceptable.
</aside>

### JSON Response

The response is in the format: `{"metadata-type": [{ metadata-hash }]}`
Here are the metadata-hash keys for the book object:

* title
* subtitle
* image
* author (Array of authors or the string 'collective work')
  * name
  * b_id
* contributors (Array of hashes)
  * job-hash (A hash in the form of job_name => [Array of authors])
* publisher
  * name
  * b_id 
* publication_year
* pages
* isbn(May be null, some books have isbn13 or some other id number)
* isbn_13 (May be null, some books dont have isbn13)
* issn (May not be there)
* ismn (May not be there, only music books have ismn)
* award (Array of awards)
  * name
  * year
* description
* category (Array of categories)
  * name
  * ddc (Dewey Decimal Classification)
  * b_id 
* b_id
* publication
  * year
  * version
  * place
* format
* original_language
* original_title
* price
* availability
* last_update
* series
  * name
  * volume
* physical_description
  * pages
  * size
  * cover_type

<aside class="warning">
Be careful — Most of the above values may be null. Always check if a value is present before use.
</aside>

## Eager load a book

```shell
# These commands eager load the same book.
curl "http://bookshark.eu/api/v1/book?isbn=978-960-6640-84-1&eager=1"
curl "http://bookshark.eu/api/v1/book?id=185281&eager=1"
curl "http://bookshark.eu/api/v1/book?uri=http://biblionet.gr/book/185281/&eager=1"

```

> The above commands return JSON structured like this:

```json
{
  "book": [
    {
      "title": "Τα μαθηματικά της ζωής",
      "subtitle": "Ξεκλειδώνοντας τα μυστικά της ύπαρξης",
      "image": "http://www.biblionet.gr/images/covers/b185281.jpg",
      "author": [
        {
          "name": "Stewart, Ian",
          "firstname": "Ian",
          "lastname": "Stewart",
          "extra_info": "1945-",
          "image": "http://www.biblionet.gr/images/persons/4647.jpg",
          "bio": "Ο Ίαν Στιούαρτ γεννήθηκε στην Αγγλία στο Folkestone...",
          "award": [
          ],
          "b_id": "4647"
        }
      ],
      "contributors": {
        "μετάφραση": [
          {
            "name": "Αποστολόπουλος, Νίκος",
            "firstname": "Νίκος",
            "lastname": "Αποστολόπουλος",
            "extra_info": "μεταφραστής",
            "image": null,
            "bio": "",
            "award": [
            ],
            "b_id": "86407"
          }
        ],
        "επιμέλεια": [
          {
            "name": "Τάρτας, Αθανάσιος",
            "firstname": "Αθανάσιος",
            "lastname": "Τάρτας",
            "extra_info": null,
            "image": null,
            "bio": "Ο Αθανάσιος Τάρτας είναι βιολόγος-βιοχημικός, MSc, PhSD.",
            "award": [
            ],
            "b_id": "105693"
          }
        ]
      },
      "publisher": [
        {
          "name": "Τραυλός",
          "owner": "Τραυλός Παναγιώτης",
          "bookstores": {
            "Έδρα": {
              "address": [
                "Καλλιδρομίου 54Α",
                "114 73 Αθήνα"
              ],
              "telephone": [
                "210 3814410",
                "210 3813591"
              ],
              "fax": "210 3828174",
              "email": "travl@acci.gr",
              "website": "www.travlos.gr"
            }
          },
          "b_id": "451"
        }
      ],
      "publication_year": "2012",
      "pages": "572",
      "isbn": "978-960-6640-84-1",
      "isbn_13": "978-960-6640-84-1",
      "award": [
      ],
      "description": "...Τα μυστικά της ύπαρξης, η ίδια η φύση της ζωής, δεν είναι απλώς ζήτημα βιοχημείας....",
      "category": [
        {
          "192": {
            "ddc": "500",
            "name": "Φυσικές και θετικές επιστήμες",
            "parent": null
          },
          "8344": {
            "ddc": "500",
            "name": "Φυσικές και θετικές επιστήμες - Γενικά έργα",
            "parent": "192"
          },
          "57": {
            "ddc": "510",
            "name": "Μαθηματικά",
            "parent": "192"
          },
          "_comment": "More child categories are condensed...",
          "1429": {
            "ddc": "590",
            "name": "Ζωολογία",
            "parent": "192"
          },
          "current": {
            "ddc": "500",
            "name": "Φυσικές και θετικές επιστήμες",
            "parent": null,
            "b_id": "192"
          }
        },
        {
          "_comment": "More category trees are condensed..."
        }
      ],
      "b_id": "185281",
      "publication": {
        "year": "2012",
        "version": "1",
        "place": "Αθήνα"
      },
      "format": "Βιβλίο",
      "original_language": "αγγλικά",
      "original_title": "Mathematics of Life",
      "price": "22,00",
      "availability": "Κυκλοφορεί",
      "last_update": "27/12/2012",
      "series": {
      },
      "physical_description": {
        "pages": "572",
        "size": "21x14",
        "cover_type": "Μαλακό εξώφυλλο"
      }      
    }
  ]
}
```

Each book has some attributes such as authors, contributors, categories etc which are actually references to other objects.
By default when extracting a book, you get only names of these objects and references to their pages.
With eager option set to true, each of these objects' data is extracted and the produced output contains complete information about every object.
You can enable eager loading by set eager parameter to 1.

### Some example requests

`GET http://bookshark.eu/api/v1/book?isbn=960-14-1157-7&eager=1`

`GET http://bookshark.eu/api/v1/book?id=103788&eager=1`

`GET http://bookshark.eu/api/v1/book?isbn=978-960-14-1157-6&eager=1`

### JSON Response

The response is in the same format as the plain book above: 
`{"metadata-type": [{ metadata-hash }]}`, but with more attributes in authors, contributors, publishers and categories.
Here are the metadata-hash keys for the book object:

* title
* subtitle
* image
* author (Array of authors)
  * name
  * firstname
  * lastname
  * extra_info
  * bio
  * image
  * award (Array of awards)
    * name
    * year
  * b_id
* contributors (Array of hashes)
  * job-hash (A hash in the form of job_name => [Array of authors])
* publisher
  * name
  * owner
  * bookstores (A hash of bookstores in the form of bookstore_title => {bookstore-data}})
    * address (Array of addresses)
    * telephone (Array of telephones)
    * fax
    * email
    * website
  * b_id 
* publication_year
* pages
* isbn
* isbn_13 (May be null, some books dont have isbn13)
* issn (May not be there)
* ismn (May not be there, only music books issn)
* award (Array of awards)
  * name
  * year
* description
* category (Array of category hierarchies in form: category-id => category-data)
  * name
  * ddc (Dewey Decimal Classification)
  * b_id 
  * parent
* b_id
* publication
  * year
  * version
  * place
* format
* original_language
* original_title
* price
* availability
* last_update
* series
  * name
  * volume
* physical_description
  * pages
  * size
  * cover_type

<aside class="warning">
Warning — Eager loading of a book is very slow. It is better to normally extract a book and then extract metadata about a specific author or publisher.
</aside>

## Search Books

```shell
# Get books with title ανδρομαχη by author ευριπιδης.
curl "http://bookshark.eu/api/v1/search?title=ανδρομαχη&author=ευριπιδης"
# Get books with title χομπιτ by author τολκιν (setting results to metadata is optional because it is the default type anyway).
curl "http://bookshark.eu/api/v1/search?title=χομπιτ&author=τολκιν&results_type=metadata"
# Get only the ids of books with title χομπιτ by author τολκιν
curl "http://bookshark.eu/api/v1/search?title=αρχοντας&author=τολκιν&results_type=ids"
# Get books by author arthur doyle, published after 2010.
curl "http://bookshark.eu/api/v1/search?author=arthur%20doyle&after_year=2010"
# Get books with isbn 978-960-14-1157-6
curl "http://bookshark.eu/api/v1/search?isbn=978-960-14-1157-6"

```

> Search results create a collection of books, same as if each book has been extracted on its own.

```json
{
  "book": [
    {
      "title": "Στης Χλόης τα απόκρυφα",
      "subtitle": "…και άλλα σημεία και τέρατα",
      "... Rest of Metadata ...": "... condensed ..."
    },
    {
      "title": "Σημεία και τέρατα της οικονομίας",
      "subtitle": "Η κρυφή πλευρά των πάντων",
      "... Rest of Metadata ...": "... condensed ..."     
    },
    {
      "title": "Και άλλα σημεία και τέρατα από την ιστορία",
      "subtitle": null,
      "... Rest of Metadata ...": "... condensed ..."
    },
    {
      "title": "Σημεία και τέρατα από την ιστορία",
      "subtitle": null,
      "... Rest of Metadata ...": "... condensed ..."      
    }
  ]
}
```

> Results with results_type option set to ids look like this:

```json 
{
 "book": [
    "119000",
    "103788",
    "87815",
    "87812",
    "15839",
    "77381",
    "46856",
    "46763",
    "33301"
  ]
}
```

Instead of getting a specific book by providing the book's isbn or id, a search function can be used to get one or more books based on some parameters. This is the only way to search for books when you don't know the isbn or you want to get a collection of more than one books.


### HTTP Request

`GET http://bookshark.eu/api/v1/search?parameters`

### Query Parameters

In each request only one of isbn, id and uri should be used to specify the book.

Parameter | Description
--------- | -----------
isbn | The book's ISBN code.
id | The book's id in biblionet site.
uri | The book's url in biblionet site.
eager | If set to 1, it activates eager book extraction.
title | The title of book to search       
author | The author's last name is enough for filter the search      
publisher | The publisher of book to search 
category | The category of book to search 
title_split | How the given title is matched, options are:<ul><li>0 The exact title phrase must by matched</li><li>1 Default - All the words in title must be matched in whatever order</li><li>2 At least one word should match</li></ul>
book_id | Providing id means only one book should returned      
isbn | The ISBN or ISBN13 of book to search        
author_id | ID of the selected author    
publisher_id | ID of the selected publisher
category_id | ID of the selected category
after_year | Published this year or later   
before_year | Published this year or before   
results_type | In what form are the returned results, options are:<ul><li>metadata - (Default) Every book is extracted and an array of metadata is</li><li>ids - Only ids are returned</li></ul>

<aside class="notice">
Searching and extracting several books can be very slow at times, so instead of extracting every single book you may prefer only the ids of found books. In that case pass the option `results_type: 'ids'`.
</aside>

### Some example requests

It is recommended to use at least two parameters if you trying to get a specific book. Here some examples of search request

`GET http://bookshark.eu/api/v1/search?title=ανδρομαχη&author=ευριπιδης`

`GET http://bookshark.eu/api/v1/search?title=χομπιτ&author=τολκιν&results_type=metadata`

`GET http://bookshark.eu/api/v1/search?author=arthur%20doyle&after_year=2010`

`GET http://bookshark.eu/api/v1/search?isbn=978-960-14-1157-6`

`GET http://bookshark.eu/api/v1/search?title=αρχοντας&author=τολκιν&results_type=ids`

<aside class="warning">
Don't forget to url encode your requests 
ie. http://bookshark.eu/api/v1/search?title=σημεια και τερατα should become http://bookshark.eu/api/v1/search?title=σημεια%20και%20τερατα before making the request.
</aside>
