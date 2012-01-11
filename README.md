# Iqvoc::SKOSXL

This is the iQvoc SKOS-XL extension. Use this in your Gemfile to add SKOS-XL features to iQvoc.

Iqvoc::SKOSXL may run in two different modes: Standalone as Application and embedded into another Application as Engine.

## Standalone Application

Operate Iqvoc::SKOSXL like a common iQvoc-based Application.

1. Run database migrations:
    `rake db:migrate_all`
2. Populate iQvoc seeds:
    `rake db:seed_all`

## Engine

Operate Iqvoc::SKOSXL and Iqvoc as Engines running in a custom App.

1. Add iqvoc_skosxl to your Gemfile (beneath iqvoc)
2. Run Iqvoc migrations:
    `rake db:migrate_all`
3. Populate Iqvoc seeds:
    `rake db:seed_all`
