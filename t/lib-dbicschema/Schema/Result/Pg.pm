use utf8;
package Schema::Result::Pg;

# Created manually by nohuhu to test Postgres specific data types
# PLEASE GO AHEAD AND MODIFY WHATEVER YOU NEED

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table("pg");
__PACKAGE__->add_columns(
    "id",
    { data_type => "uuid", is_nullable => 0 },
    "enum_column",
    {
        data_type => "enum",
        extra => { custom_type_name => "custom_type", list => ["foo", "bar", "baz space"] },
        is_nullable => 0,
    },
    "timestamp_with_tz",
    { data_type => "timestamp with time zone", is_nullable => 1 },
    "timestamp_without_tz",
    { data_type => "timestamp without time zone", is_nullable => 0 },
    "another_enum_column",
    {
        data_type => "enum",
        extra => { custom_type_name => "custom_type", list => ["foo", "bar", "baz space"] },
        is_nullable => 0,
    },
);
__PACKAGE__->set_primary_key("id");

1;
