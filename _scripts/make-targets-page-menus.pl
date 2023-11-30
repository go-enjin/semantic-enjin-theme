#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use constant
  {
   TOP_LEVEL => 7,
   MAX_DEPTH => 10,
  };
$|=1;

#:
#: main
#:

my $data_side           = "[data-mobile-style='side'],[data-desktop-style='side'],[data-mobile-style='slide'],[data-desktop-style='slide']";
my $data_menu           = "[data-mobile-style='menu'],[data-desktop-style='menu']";
my $data_mega           = "[data-mobile-style='mega'],[data-desktop-style='mega']";
my $data_side_menu      = $data_side.",".$data_menu;
my $data_side_menu_mega = $data_side.",".$data_menu.",".$data_mega;

#:
#: For any checked menu item: display immediate children and closing labels
#:

for (my $i=1; $i<=TOP_LEVEL; $i++) {
  my @display = ();

  push(@display, "#menu-${i}:checked~header .menus:is(${data_side_menu})>nav #menu-item-${i}--close");
  push(@display, "#menu-${i}:checked~header .menus:is(${data_side_menu_mega})>nav #menu-item-${i}>:is(ul,ol)");
  for (my $j=1; $j<=MAX_DEPTH; $j++) {
    push(@display, "#menu-${i}-${j}:checked~header .menus:is(${data_side_menu})>nav :is(#menu-item-${i}--close,#menu-item-${i}-${j}--close)");
    push(@display, "#menu-${i}-${j}:checked~header .menus:is(${data_side_menu_mega})>nav :is(#menu-item-${i},#menu-item-${i}-${j})>:is(ul,ol)");
    for (my $k=1; $k<=MAX_DEPTH; $k++) {
      push(@display, "#menu-${i}-${j}-${k}:checked~header .menus:is(${data_side_menu})>nav :is(".
           "#menu-item-${i}--close,".
           "#menu-item-${i}-${j}--close,".
           "#menu-item-${i}-${j}-${k}--close".
           ")");
      push(@display, "#menu-${i}-${j}-${k}:checked~header .menus:is(${data_side_menu_mega})>nav :is(".
           "#menu-item-${i},".
           "#menu-item-${i}-${j},".
           "#menu-item-${i}-${j}-${k}".
           ")>:is(ul,ol)");
    }
  }

  print join(",\n", @display);
  print "{display:flex;}\n";
}

#:
#: For any checked menu item with children: change the item.parent indicator to --icon--opened--content
#:

for (my $i=1; $i<=TOP_LEVEL; $i++) {
  my @content = ();

  push(@content, "#menu-${i}:checked~header .menus:is(${data_side_menu})>nav #menu-item-${i}>.parent::after");
  for (my $j=1; $j<=MAX_DEPTH; $j++) {
    push(@content, "#menu-${i}-${j}:checked~header .menus:is(${data_side_menu})>nav :is(#menu-item-${i},#menu-item-${i}-${j})>.parent::after");
    for (my $k=1; $k<=MAX_DEPTH; $k++) {
      push(@content, "#menu-${i}-${j}-${k}:checked~header .menus:is(${data_side_menu})>nav :is(".
           "#menu-item-${i},".
           "#menu-item-${i}-${j},".
           "#menu-item-${i}-${j}-${k}".
           ")>.parent::after");
    }
  }

  print join(",\n", @content);
  print "{content:var(--icon--opened--content);};\n";
}

#:
#: For any checked menu item: swap the fg and bg color variables to visually indicate the active status
#:

for (my $i=1; $i<=TOP_LEVEL; $i++) {
  my @colours = ();

  push(@colours, "#menu-${i}:checked~.masthead .menus:not(${data_side}) #menu-item-${i}--label");
  push(@colours, "#menu-${i}:checked~.masthead .menus:not(${data_side}) #menu-item-${i}--label :is(a,a:hover,a:active,a:visited,a:focus)");
  for (my $j=1; $j<=MAX_DEPTH; $j++) {
    push(@colours, "#menu-${i}-${j}:checked~.masthead .menus:not(${data_side}) :is(#menu-item-${i}--label,#menu-item-${i}-${j}--label)");
    push(@colours, "#menu-${i}-${j}:checked~.masthead .menus:not(${data_side}) :is(#menu-item-${i}--label,#menu-item-${i}-${j}--label) :is(a,a:hover,a:active,a:visited,a:focus)");
    for (my $k=1; $k<=MAX_DEPTH; $k++) {
      push(@colours, "#menu-${i}-${j}-${k}:checked~.masthead .menus:not(${data_side}) :is(".
           "#menu-item-${i}--label,".
           "#menu-item-${i}-${j}--label,".
           "#menu-item-${i}-${j}-${k}--label".
           ")");
      push(@colours, "#menu-${i}-${j}-${k}:checked~.masthead .menus:not(${data_side}) :is(".
           "#menu-item-${i}--label,".
           "#menu-item-${i}-${j}--label,".
           "#menu-item-${i}-${j}-${k}--label".
           ") :is(a,a:hover,a:active,a:visited,a:focus)");
    }
  }

  print join(",\n", @colours);
  print "{color:var(--page--masthead--bg);background:var(--page--masthead--fg);}\n";
}

exit(0);