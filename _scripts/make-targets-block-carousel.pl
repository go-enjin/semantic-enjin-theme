#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
$|=1;

use constant { MAX_CARDS => 50 };

sub prepare_is_selectors {
  my ($offset,$start, $end, $prefix, $suffix) = @_;
  my $limit = MAX_CARDS - 1;
  my @selectors = ();
  foreach my $l ($offset..$limit) {
    my @is = ();
    for (my $i=0; $i<=($l+$end); $i++) {
      next if ($i < $start);
      push(@is, "[data-card='${i}']:target");
    }
    my $is_clause = "";
    if (@is > 1) {
      $is_clause = ":is(".join(",",@is).")";
    } elsif (@is) {
      $is_clause = $is[0];
    }
    next unless ($is_clause);
    my $modified = "${prefix}[data-carousel-last-card='{i}'] ${is_clause} ~ ${suffix}";
    my $lm1 = $l-1;
    my $lp1 = $l+1;
    $modified =~ s!\{i\}!$l!g;
    $modified =~ s!\{i\-1\}!$lm1!g;
    $modified =~ s!\{i\+1\}!$lp1!g;
    push( @selectors, $modified) if (@is);
  }
  return @selectors;
}

sub prepare_tmpl_selectors {
  my ($start,$tmpl) = @_;
  my $limit = MAX_CARDS - 1;
  my @selectors = ();
  foreach my $l ($start..$limit) {
    my $modified = $tmpl;
    my $lm1 = $l-1;
    my $lp1 = $l+1;
    $modified =~ s!\{i\}!$l!g;
    $modified =~ s!\{i\-1\}!$lm1!g;
    $modified =~ s!\{i\+1\}!$lp1!g;
    push( @selectors, $modified);
  }
  return @selectors;
}

#:
#: initial setup
#:

# /* track and adjust for gaps */

print "/* all bookends: track css card count */\n";
print join("\n",prepare_tmpl_selectors(0, "[data-block-type='carousel'][data-carousel-bookends][data-carousel-last-card='{i}'] { --block--carousel--total-cards: {i+1}; }"));
print "/* all bookends: track css target card */\n";
print join("\n",prepare_tmpl_selectors(0, "[data-block-type='carousel'][data-carousel-bookends] [data-card='{i}']:target ~ .carousel { --block--carousel--target-card: {i+1}; }"));

# /* middle and ending targets need first nav dot normal */

print "/* middle and ending targets need first nav dot normal, regardless of bookends */\n";
print join(",\n",prepare_is_selectors(0, 1,0,"",".dots>ol>[data-card='0']"));
print " {
  font-size: var(--block--carousel--nav-dot-size);
}
";

# /* middle and ending targets need first-card nav tags hidden */

print "/* middle and ending targets need first-card nav tags hidden */\n";
print join(",\n",prepare_is_selectors(0, 1,0,"",".carousel>nav [data-card='0']"));
print " {
  display: none;
}
";

print "/* target cards need nav tags visible */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-block-type='carousel'] [data-card='{i}']:target ~ .carousel>nav [data-card='{i}']"));
print " {
  display: inline-block;
}
";

# /* focus current target nav dot */

print "/* focus current target nav dot */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-block-type='carousel'] [data-card='{i}']:target ~ nav>ol>li[data-card='{i}']"));
print " {
  font-size: var(--block--carousel--nav-dot-size-active);
}
";

#:
#: one bookend setup
#:

print "/* 1 bookend: tablet, desktop responsiveness */\n";
print '@media screen and (min-width: 768px) {'."\n";
print "
[data-block-type='carousel'][data-carousel-bookends='1']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2']),
[data-block-type='carousel'][data-carousel-bookends='2']:is([data-carousel-last-card='3']) {
  --block--carousel--bookend-width: 15%;
  --block--carousel--card-width:    calc(100% - (var(--block--carousel--bookend-width) * 2));
}
";

# /* re-order last-card to first position */

print "/* 1 bookend: re-order last-card to first position */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-last-card='{i}']:is([data-carousel-bookends='1']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2']),[data-carousel-bookends='2']:is([data-carousel-last-card='3'])) [data-card='{i}']:not(:target) ~ .carousel>.cards>[data-card='{i}']"));
print " {
  order: -1;
}
";

# /* middle targets need the first-card to be offset */

print "/* 1 bookend: middle targets need the first-card to be offset */\n";
print join(",\n",prepare_is_selectors(0, 1,-1,"[data-carousel-last-card='{i}']:is([data-carousel-bookends='1']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2']),[data-carousel-bookends='2']:is([data-carousel-last-card='3']))",".carousel>.cards>[data-card='0']"));
print " {
  margin-left: calc(1 * var(--block--carousel--card-width));
}
";

# /* last-card target needs first-card to be last position */

print "/* 1 bookend: last-card target needs first-card to be last position */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-last-card='{i}']:is([data-carousel-bookends='1']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2']),[data-carousel-bookends='2']:is([data-carousel-last-card='3'])) [data-card='{i}']:target ~ .carousel>.cards>[data-card='0']"));
print " {
  margin-left: 0;
  order: 2;
}
";

# /* ending targets needs the second-card to be twice offset */

print "/* 1 bookend: last-card target needs the second-card to be twice offset */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-last-card='{i}']:is([data-carousel-bookends='1']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2']),[data-carousel-bookends='2']:is([data-carousel-last-card='3'])) [data-card='{i}']:target ~ .carousel>.cards>[data-card='1']"));
print " {
  margin-left: calc(2 * var(--block--carousel--card-width));
}
";

# /* middle and ending targets need the last-card in natural position */

print "/* 1 bookend: middle and ending targets need the last-card in natural position */\n";
print join(",\n",prepare_is_selectors(0, 1,0,"[data-carousel-last-card='{i}']:is([data-carousel-bookends='1']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2']),[data-carousel-bookends='2']:is([data-carousel-last-card='3']))",".carousel>.cards>[data-card='{i}']"));
print " {
  order: 1;
}
";

print "} /* 1 bookend: tablet, desktop responsiveness */\n";

#:
#: two bookends tablet setup
#:

print "/* 2 bookends: tablet responsiveness */\n";
print '@media screen and (min-width: 768px) and (max-width: 1199.99px) {'."\n";
print "
[data-block-type='carousel'][data-carousel-bookends='2']:not(
  [data-carousel-last-card='0'],
  [data-carousel-last-card='1'],
  [data-carousel-last-card='2'],
  [data-carousel-last-card='3']
) {
  --block--carousel--bookend-width: 15%;
  --block--carousel--card-width:    calc(100% - (var(--block--carousel--bookend-width) * 2));
}
";

# /* re-order last-card to first position */

print "/* 2 bookends: re-order last-card to first position */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-bookends='2'][data-carousel-last-card='{i}']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])
 [data-card='{i}']:not(:target) ~ .carousel>.cards>[data-card='{i}']"));
print " {
  order: -1;
}
";

# /* middle targets need the first-card to be offset */

print "/* 2 bookends: middle targets need the first-card to be offset */\n";
print join(",\n",prepare_is_selectors(0, 1,-1,"[data-carousel-bookends='2']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])",".carousel>.cards>[data-card='0']"));
print " {
  margin-left: calc(1 * var(--block--carousel--card-width));
}
";

# /* last-card target needs first-card to be last position */

print "/* 2 bookends: ending target needs first-card to be last position */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-bookends='2'][data-carousel-last-card='{i}']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3']) [data-card='{i}']:target ~ .carousel>.cards>[data-card='0']"));
print " {
  margin-left: 0;
  order: 2;
}
";

# /* ending targets needs the second-card to be twice offset */

print "/* 2 bookends: ending target needs the second-card to be twice offset */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-bookends='2'][data-carousel-last-card='{i}']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3']) [data-card='{i}']:target ~ .carousel>.cards>[data-card='1']"));
print " {
  margin-left: calc(2 * var(--block--carousel--card-width));
}
";

# /* middle and ending targets need the last-card in natural position */

print "/* 1 bookend: middle and ending targets need the last-card in natural position */\n";
print join(",\n",prepare_is_selectors(0, 1,0,"[data-carousel-bookends='2']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])",".carousel>.cards>[data-card='{i}']"));
print " {
  order: 1;
}
";

print "} /* 2 bookends: desktop responsiveness */\n";

#:
#: two bookends desktop setup
#:

print "/* 2 bookends: desktop responsiveness */\n";
print '@media screen and (min-width: 1200px) {'."\n";
print "
[data-block-type='carousel'][data-carousel-bookends='2']:not(
  [data-carousel-last-card='0'],
  [data-carousel-last-card='1'],
  [data-carousel-last-card='2'],
  [data-carousel-last-card='3']
) {
  --block--carousel--card-width:    25%;
  --block--carousel--bookend-width: calc(var(--block--carousel--card-width) / 2);
}
";

# /* middle targets need the first-card to be offset */

print "/* 2 bookends: second target needs the last-card to be once offset */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-bookends='2'][data-carousel-last-card='{i}']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])
 [data-card='1']:target ~ .carousel>.cards>[data-card='{i}']"));
print " {
  margin-left: calc(1 * var(--block--carousel--card-width));
}
";
print "/* 2 bookends: middle targets need the first-card to be twice offset */\n";
print join(",\n",prepare_is_selectors(0, 2,-2,"[data-carousel-bookends='2']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])",".carousel>.cards>[data-card='0']"));
print " {
  margin-left: calc(2 * var(--block--carousel--card-width));
}
";

# /* ending targets needs the second-card to be twice offset */

print "/* 2 bookends: ending targets need the first-middle-card to be double twice offset */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-bookends='2'][data-carousel-last-card='{i}']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3']) [data-card='{i-1}']:target ~ .carousel>.cards>[data-card='1']"));
print " {
  margin-left: calc(3 * var(--block--carousel--card-width));
}
";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-bookends='2'][data-carousel-last-card='{i}']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3']) [data-card='{i}']:target ~ .carousel>.cards>[data-card='2']"));
print " {
  margin-left: calc(4 * var(--block--carousel--card-width));
}
";

# /* re-order last-card to first position */

print "/* 2 bookends: re-order ending cards to starting positions */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-bookends='2'][data-carousel-last-card='{i}']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])
 .carousel>.cards>:is([data-card='{i-1}'],[data-card='{i}'])"));
print " {
  order: -1;
}
";

# /* middle and ending targets need the last-card in natural position */

print "/* 2 bookends: middle and ending targets need the ending card in natural position */\n";
print join(",\n",prepare_is_selectors(0, 1,0,
"[data-carousel-bookends='2']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])",
".carousel>.cards>[data-card='{i-1}']")
);
print ",\n";
print join(",\n",prepare_is_selectors(0, 2,0,
"[data-carousel-bookends='2']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])",
".carousel>.cards>[data-card='{i}']")
);
print " {
  order: 1;
}
";

# /* last-card target needs first-card to be last position */

print "/* 2 bookends: ending targets need starting cards to be last position */\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-bookends='2'][data-carousel-last-card='{i}']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])
 [data-card='{i-1}']:target ~ .carousel>.cards>[data-card='0']"));
print ",\n";
print join(",\n",prepare_tmpl_selectors(0, "[data-carousel-bookends='2'][data-carousel-last-card='{i}']:not([data-carousel-last-card='0'],[data-carousel-last-card='1'],[data-carousel-last-card='2'],[data-carousel-last-card='3'])
 [data-card='{i}']:target ~ .carousel>.cards>:is([data-card='0'],[data-card='1'])"));
print " {
  margin-left: 0;
  order: 2;
}
";

print "} /* 2 bookends: desktop responsiveness */\n";
