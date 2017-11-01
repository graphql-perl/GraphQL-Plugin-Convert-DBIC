# NAME

GraphQL::Plugin::Convert::DBIC - convert DBIx::Class schema to GraphQL schema

# PROJECT STATUS

| OS      |  Build status |
|:-------:|--------------:|
| Linux   | [![Build Status](https://travis-ci.org/graphql-perl/GraphQL-Plugin-Convert-DBIC.svg?branch=master)](https://travis-ci.org/graphql-perl/GraphQL-Plugin-Convert-DBIC) |

[![CPAN version](https://badge.fury.io/pl/GraphQL-Plugin-Convert-DBIC.svg)](https://metacpan.org/pod/GraphQL::Plugin::Convert::DBIC)

# SYNOPSIS

    use GraphQL::Plugin::Convert::DBIC;
    use Schema;
    my $converted = GraphQL::Plugin::Convert::DBIC->to_graphql(Schema->connect);
    print $converted->{schema}->to_doc;

# DESCRIPTION

This module implements the [GraphQL::Plugin::Convert](https://metacpan.org/pod/GraphQL::Plugin::Convert) API to convert
a [DBIx::Class::Schema](https://metacpan.org/pod/DBIx::Class::Schema) to [GraphQL::Schema](https://metacpan.org/pod/GraphQL::Schema) etc.

Its `Query` type represents a guess at what fields are suitable, based
on providing a lookup for each type (a [DBIx::Class::ResultSource](https://metacpan.org/pod/DBIx::Class::ResultSource))
by each of its columns.

The `Mutation` type is similar: one `create/update/delete(type)` per
"real" type.

# ARGUMENTS

To the `to_graphql` method: a [DBIx::Class::Schema](https://metacpan.org/pod/DBIx::Class::Schema) object.

# DEBUGGING

To debug, set environment variable `GRAPHQL_DEBUG` to a true value.

# AUTHOR

Ed J, `<etj at cpan.org>`

# LICENSE

Copyright (C) Ed J

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
