data "external_schema" "hibernate" {
  program = [
    "/bin/sh",
    "-c",
    "mvn compile -Dproperties=schema-export.properties -Denable-table-generators -q hibernate-provider:schema"
  ]
}

env "local" {
    // Source SQL from above
    src = data.external_schema.hibernate.url

    // Dev Database concept used by AtlasGo
    dev = "docker://postgres/15/dev?search_path=public"

    // Local machine database
    url = "postgres://postgres:password@localhost:5432/atlas?search_path=public&sslmode=disable"

    migration {
        // URL where the migration directory resides.
        dir = "file://migrations"
    }
    format {
        migrate {
            diff = "{{ sql . \" \" }}"
        }
    }
}