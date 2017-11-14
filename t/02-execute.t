use strict;
use Test::More 0.98;
use File::Spec;
use lib 't/lib-dbicschema';
use Schema;
use GraphQL::Execution qw(execute);
use Data::Dumper;
use File::Temp qw/ tempfile tempdir /;

use_ok 'GraphQL::Plugin::Convert::DBIC';

sub run_test {
  my ($args, $expected) = @_;
  my $got = execute(@$args);
  is_deeply $got, $expected or diag nice_dump($got);
}

sub nice_dump {
  my ($got) = @_;
  local ($Data::Dumper::Sortkeys, $Data::Dumper::Indent, $Data::Dumper::Terse);
  $Data::Dumper::Sortkeys = $Data::Dumper::Indent = $Data::Dumper::Terse = 1;
  Dumper $got;
}

my $dbic_class = 'Schema';
my $dir = tempdir( CLEANUP => 1 );
my ($tfh, $filename) = tempfile( DIR => $dir );
print $tfh do { open my $fh, 't/test.db'; binmode $fh; join '', <$fh> };
close $tfh;
my $converted = GraphQL::Plugin::Convert::DBIC->to_graphql(
  sub { $dbic_class->connect("dbi:SQLite:$filename") }
);

subtest 'execute pk + deeper query' => sub {
  my $doc = <<'EOF';
{
  blog(id: [1, 2]) {
    id
    title
    tags {
      name
    }
  }
  photo(id: [4730349774, 4730337840]) {
    id
    description
    photosets {
      id
      title
    }
  }
}
EOF
  run_test(
    [
      $converted->{schema}, $doc, $converted->{root_value},
      (undef) x 3, $converted->{resolver},
    ],
    {
      data => {
        blog => [
          {
            id => 1,
            tags => [ { name => "personal" }, { name => "test" } ],
            title => "Hello!",
          },
          {
            id => 2,
            tags => [ { name => "tech" } ],
            title => "Tech",
          }
        ],
        photo => [
          {
            description => '',
            id => '4730337840',
            'photosets' => [
              { id => '72157624222825789', title => 'Robot Arms' }
            ],
          },
          {
            description => 'Again - receding hairpieces please!',
            id => '4730349774',
            photosets => [
              { id => '72157624222820921', title => 'Head Museum' }
            ],
          },
        ],
      }
    }
  );
};

subtest 'execute search query' => sub {
  my $doc = <<'EOF';
{
  searchBlogTag(input: { name: "tech" }) {
    id
    name
    blog {
      title
    }
  }
}
EOF
  run_test(
    [
      $converted->{schema}, $doc, $converted->{root_value},
      (undef) x 3, $converted->{resolver},
    ],
    {
      data => {
        searchBlogTag => [
          {
            blog => { title => 'Tech' },
            id => 3,
            name => 'tech',
          }
        ],
      }
    }
  );
};

done_testing;
