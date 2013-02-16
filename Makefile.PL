use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Text::Convert::PETSCII',
    VERSION_FROM      => 'PETSCII.pm',
    PREREQ_PM         => { 'IO::Capture' => 0,
                         },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'PETSCII.pm',
       AUTHOR         => 'Pawel Krol <pawelkrol@cpan.org>') : ()),
    DEFINE            => '',
    OPTIMIZE          => '-O2',
    MIN_PERL_VERSION  => '5.8.0',
);
