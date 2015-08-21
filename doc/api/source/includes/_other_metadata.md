# Other Metadata Types

## Author

```shell
# Extracts the author with that specific id.
curl "http://bookshark.eu/api/v1/author?id=10207"
curl "http://bookshark.eu/api/v1/author?url=http://www.biblionet.gr/author/10207/"
```

> The above command return JSON structured like this:

```json
{
  "author": [
    {
      "name": "Tolkien, John Ronald Reuel",
      "firstname": "John Ronald Reuel",
      "lastname": "Tolkien",
      "extra_info": "1892-1973",
      "image": "http://www.biblionet.gr/images/persons/10207.jpg",
      "bio": "Ο John Ronald Reuel Tolkien, άγγλος φιλόλογος και συγγραφέας, γεννήθηκε το 1892 στην πόλη Μπλουμφοντέιν...",
      "award": [
        {
          "name": "The Benson Medal [The Royal Society of Literature]",
          "year": "1966"
        }
      ],
      "b_id": "10207"
    }
  ]
}
```

This endpoint retrieves a specific author, based on its biblionet id or url.

### HTTP Request

`GET http://bookshark.eu/api/v1/author?parameters`

### Query Parameters

In each request only one of id or uri should be used to specify an author.

Parameter | Description
--------- | -----------
id | The author's id in biblionet site.
uri | The author's url in biblionet site.

### JSON Response

The response is in the format: `{"metadata-type": [{ metadata-hash }]}`  
Here are the metadata-hash keys for the author object:

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

<aside class="warning">
Be careful — Most of the above values may be null. Always check if a value is present before use.
</aside>

## Publisher

```shell
# Extracts the publisher with that specific id.
curl "http://bookshark.eu/api/v1/publisher?id=20"
curl "http://bookshark.eu/api/v1/publisher?url=http://biblionet.gr/com/20/"
```

> The above command return JSON structured like this:

```json
{
  "publisher": [
    {
      "name": "Εκδόσεις Πατάκη",
      "owner": "Στέφανος Πατάκης",
      "bookstores": {
        "Κεντρική διάθεση": {
          "address": [
            "Εμμ. Μπενάκη 16",
            "106 78 Αθήνα"
          ],
          "telephone": [
            "210 3831078"
          ]
        },
        "Γενικό βιβλιοπωλείο Πατάκη": {
          "address": [
            "Ακαδημίας 65",
            "106 78 Αθήνα"
          ],
          "telephone": [
            "210 3811850",
            "210 3811740"
          ]
        },
        "Έδρα": {
          "address": [
            "Παναγή Τσαλδάρη 38 (πρ. Πειραιώς)",
            "104 37 Αθήνα"
          ],
          "telephone": [
            "210 3650000",
            "210 5205600"
          ],
          "fax": "210 3650069",
          "email": "info@patakis.gr",
          "website": "www.patakis.gr"         
        }
      },
      "b_id": "20"
    }
  ]
}
```

This endpoint retrieves a specific publisher, based on its biblionet id or url.

### HTTP Request

`GET http://bookshark.eu/api/v1/publisher?parameters`

### Query Parameters

In each request only one of id or uri should be used to specify a publisher.

Parameter | Description
--------- | -----------
id | The publisher's id in biblionet site.
uri | The publisher's url in biblionet site.

### JSON Response

The response is in the format: `{"metadata-type": [{ metadata-hash }]}`  
Here are the metadata-hash keys for the publisher object:

* name
* owner
* bookstores (A hash of bookstores in the form of bookstore_title => {bookstore-data}})
  * address (Array of addresses)
  * telephone (Array of telephones)
  * fax
  * email
  * website
* b_id 

## Category

```shell
# Extracts the category and its parents/children with that specific id.
curl "http://bookshark.eu/api/v1/category?id=1041"
curl "http://bookshark.eu/api/v1/category?url=http://biblionet.gr/index/1041/"
```

> The above command return JSON structured like this:

```json
{
  "category": [
    {
      "192": {
        "ddc": "500",
        "name": "Φυσικές και θετικές επιστήμες",
        "parent": null
      },
      "1040": {
        "ddc": "520",
        "name": "Αστρονομία",
        "parent": "192"
      },
      "1041": {
        "ddc": "523",
        "name": "Πλανήτες",
        "parent": "1040"
      },
      "780": {
        "ddc": "523.01",
        "name": "Αστροφυσική",
        "parent": "1041"
      },
      "2105": {
        "ddc": "523.083",
        "name": "Πλανήτες - Βιβλία για παιδιά",
        "parent": "1041"
      },
      "576": {
        "ddc": "523.1",
        "name": "Κοσμολογία",
        "parent": "1041"
      },
      "current": {
        "ddc": "523",
        "name": "Πλανήτες",
        "parent": "1040",
        "b_id": "1041"
      }
    }
  ]
}
```

> Each category's tree is extracted from root category to last child. An extra element with key=current is added to show which category was extracted.

This endpoint retrieves a specific category's hierarchy, based on its biblionet id or url. This gets you metadata about that category and also about its parents and children.

### HTTP Request

`GET http://bookshark.eu/api/v1/category?parameters`

### Query Parameters

In each request only one of id or uri should be used to specify a category.

Parameter | Description
--------- | -----------
id | The category's id in biblionet site.
uri | The category's url in biblionet site.

### JSON Response

The response is in the format: `{"metadata-type": [{metadata-hash}]}`  
Here are the metadata-hash keys for the category object:

Each category contains an array of category hierarchies in form: category-id => category-data 

* name
* ddc (Dewey Decimal Classification)
* b_id 
* parent

<aside class="notice">
Only root category will have a root parent. When extracting a category, its whole tree from root parent to last child will be added ordered by ddc. An extra element with key equal current is added to show which category was extracted.
</aside>
