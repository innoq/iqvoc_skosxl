# Iqvoc::SKOSXL

This is the iQvoc SKOS-XL extension. Use this in your Gemfile to add SKOS-XL features to iQvoc.

Iqvoc::SKOSXL may run in two different modes: Standalone as Application and embedded into another Application as Engine.

## Standalone Application

Operate Iqvoc::SKOSXL like a common iQvoc-based Application.

1. Run Iqvoc database migrations:
    `rake iqvoc:db:migrate`
2. Run Iqvoc::SKOSXL migrations:
    `rake db:migrate`
3. Link or copy iqvoc assets:
    `rake iqvoc:assets:link` or `rake iqvoc:assets:copy`
4. Populate Iqvoc seeds:
    `rake iqvoc:db:seed`
5. Populate Iqvoc:SKOSXL seeds:
    `rake db:seed`

## Engine

Operate Iqvoc::SKOSXL and Iqvoc as Engines running in a custom App.

1. Add iqvoc_skosxl to your Gemfile (beneath iqvoc)
2. Run Iqvoc migrations:
    `rake iqvoc:db:migrate`
2. Run Iqvoc:SKOSXL migrations:
    `rake iqvoc_skosxl:db:migrate`
3. Run your own migrations:
    `rake db:migrate`
4. Link or copy iqvoc assets:
    `rake iqvoc:assets:link` or `rake iqvoc:assets:copy`
5. Iqvoc::SKOSXL doesn't have any assets yet. So you can skip this for Iqvoc::SKOSXL.
6. Populate Iqvoc seeds:
    `rake iqvoc:db:seed`
7. Populate Iqvoc:SKOSXL seeds:
    `rake iqvoc_skosxl:db:seed`
8. Populate your applications seeds:
    `rake db:seed`
