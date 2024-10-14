![CI](https://github.com/innoq/iqvoc_skosxl/workflows/CI/badge.svg?branch=main)

# Iqvoc::SKOSXL

This is the iQvoc SKOS-XL extension. Use this in your Gemfile to add SKOS-XL features to iQvoc.

Iqvoc::SKOSXL may run in two different modes: Standalone as Application and embedded into another Application as Engine.

## Standalone Application

Operate Iqvoc::SKOSXL like a common iQvoc-based Application.

1. Run database migrations:
    `rake iqvoc:db:migrate_all`
2. Populate iQvoc seeds:
    `rake iqvoc:db:seed_all`
3. Generate secret token:
    `rake iqvoc:setup:generate_secret_token`

## Engine

Operate Iqvoc::SKOSXL and Iqvoc as Engines running in a custom App.

1. Add iqvoc_skosxl to your Gemfile (beneath iqvoc)
2. Run Iqvoc migrations:
    `rake iqvoc:db:migrate_all`
3. Populate Iqvoc seeds:
    `rake iqvoc:db:seed_all`

## License

Copyright 2014 innoQ Deutschland GmbH

Licensed under the Apache License, Version 2.0
