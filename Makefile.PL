use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'Text::Convert::PETSCII',
    VERSION_FROM      => 'PETSCII.pm',
    PREREQ_PM         => { 'Capture::Tiny' => 0,
                         },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'PETSCII.pm',
       AUTHOR         => 'Pawel Krol <pawelkrol@cpan.org>') : ()),
    DEFINE            => '',
    OPTIMIZE          => '-O2',
    META_MERGE        => {
        'meta-spec' => {
            'version' => 2,
        },
        'resources' => {
            'bugtracker' => {
                'web' => 'https://github.com/pawelkrol/Text-Convert-PETSCII/issues',
            },
            'repository' => {
                'type' => 'git',
                'url'  => 'git://github.com/pawelkrol/Text-Convert-PETSCII.git',
                'web'  => 'https://github.com/pawelkrol/Text-Convert-PETSCII.git',
            },
        },
    },
);
