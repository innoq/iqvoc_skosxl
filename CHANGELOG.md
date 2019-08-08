## [2.9.2] (unpublished)

  * Drop sqlite and mysql2 support: In future we recommend and support postgresql. Other DBMS may also work due activerecord abstraction, but will be not explicitly supported.

## [2.9.1]

  * Fixed: Export SKOS : NoMethodError : add_skos_xl_labels (#10)

## [2.8.2]

  * Fixed: initial created change note creation

## [2.8.1]

  * Fixed: multiple origin delimitation in label relation edit form

## [2.8.0]

  * Fixed: several bugs (i18n, sorting)
  * Fixed: several UI glitches

## [2.7.0]

  * Added: add XL-Label search
  * Added: automatic change note creation
  * Fixed: remove faulty foreign key constraint
  * Fixed: set label review status to false if someone edits a label which was
    previously send to review
  * Fixed: multiple label assignment
