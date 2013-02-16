#!/usr/bin/perl

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Text::Convert::PETSCII',
    VERSION_FROM      => 'lib/Text/Convert/PETSCII.pm',
    PREREQ_PM         => { 'IO::Capture::Stdout' => 0,
                           'IO::Capture::Stderr' => 0,
                         },
    ($] >= 5.005 ?
      (AUTHOR         => 'Pawel Krol <pawelkrol@cpan.org>') : ()),
    DEFINE            => '',
    OPTIMIZE          => '-O2',
);
