#########################
use strict;
use warnings;
use IO::Capture::Stderr;
use IO::Capture::Stdout;
use Test::More qw/no_plan/;
#########################
{
BEGIN { use_ok(q{Text::Convert::PETSCII}, qw{:all}) };
}
#########################
{
    is(Text::Convert::PETSCII::_is_integer(0x41), 1, q{_is_integer - check if integer value is properly recognized});
}
#########################
{
    is(Text::Convert::PETSCII::_is_integer(3.14), 0, q{_is_integer - check if numeric value is properly recognized});
}
#########################
{
    is(Text::Convert::PETSCII::_is_integer(q{x}), 0, q{_is_integer - check if character string is properly recognized});
}
#########################
{
    is(Text::Convert::PETSCII::_is_string(0x41), 0, q{_is_string - check if integer value is properly recognized});
}
#########################
{
    is(Text::Convert::PETSCII::_is_string(3.14), 0, q{_is_string - check if numeric value is properly recognized});
}
#########################
{
    is(Text::Convert::PETSCII::_is_string(q{x}), 1, q{_is_string - check if character string is properly recognized});
}
#########################
{
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    write_petscii_char(*STDOUT, [1, 2, 3]);
    $capture->stop();
    like($capture->read, qr/^\QNot a valid PETSCII character to write: [1,2,3] (expected integer code or character byte)\E/, q{write_petscii_char - warns on passing array reference});
}
#########################
{
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0.4);
    $capture->stop();
    like($capture->read, qr/^\QNot a valid PETSCII character to write: '0.4' (expected integer code or character byte)\E/, q{write_petscii_char - warns on passing floating point});
}
#########################
{
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0x1f);
    $capture->stop();
    like($capture->read, qr/^\QValue out of range: "0x1f" (PETSCII character set supports printable characters in the range of 0x20 to 0x7f and 0xa0 to 0xff)\E/, q{write_petscii_char - warns on passing number too small});
}
#########################
{
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0x100);
    $capture->stop();
    like($capture->read, qr/^\QValue out of range: "0x100" (PETSCII character set supports printable characters in the range of 0x20 to 0x7f and 0xa0 to 0xff)\E/, q{write_petscii_char - warns on passing number too large});
}
#########################
{
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    write_petscii_char(*STDOUT, q{});
    $capture->stop();
    like($capture->read, qr/^\QPETSCII character byte missing, nothing to be printed out\E/, q{write_petscii_char - warns on passing empty string});
}
#########################
{
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    write_petscii_char(*STDOUT, 'xyz');
    $capture->stop();
    like($capture->read, qr/^\QPETSCII character string too long: 3 bytes (currently writing only a single character is supported)\E/, q{write_petscii_char - warns on passing more than single byte});
}
#########################
{
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    set_petscii_write_mode('unknown');
    $capture->stop();
    like($capture->read, qr/^\QFailed to set PETSCII write mode, invalid PETSCII write mode: "unknown"\E/, q{set_petscii_write_mode - warns on setting invalid PETSCII write mode});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, ascii_to_petscii('a'));
    $capture->stop();
    my $petscii_a = <<PETSCII;
---**---
--****--
-**--**-
-******-
-**--**-
-**--**-
-**--**-
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII character byte ('a')});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, ascii_to_petscii(' '));
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
--------
--------
--------
--------
--------
--------
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII character byte (' ')});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, ascii_to_petscii('?'));
    $capture->stop();
    my $petscii_a = <<PETSCII;
--****--
-**--**-
-----**-
----**--
---**---
--------
---**---
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII character byte ('?')});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, ascii_to_petscii('@'));
    $capture->stop();
    my $petscii_a = <<PETSCII;
--****--
-**--**-
-**-***-
-**-***-
-**-----
-**---*-
--****--
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII character byte ('@')});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, ascii_to_petscii(']'));
    $capture->stop();
    my $petscii_a = <<PETSCII;
--****--
----**--
----**--
----**--
----**--
----**--
--****--
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII character byte (']')});
}
#########################
{
    eval { my $screen_code = Text::Convert::PETSCII::_petscii_to_screen_code(-1); };
    like($@, qr/^\QInvalid PETSCII integer code: "0xff\E/, q{_petscii_to_screen_code - dies on passing negative PETSCII character code});
}
#########################
{
    eval { my $screen_code = Text::Convert::PETSCII::_petscii_to_screen_code(0x100); };
    like($@, qr/^\QInvalid PETSCII integer code: "0x100\E/, q{_petscii_to_screen_code - dies on passing non-singlebyte PETSCII character code});
}
#########################
{
    my $screen_code = Text::Convert::PETSCII::_petscii_to_screen_code(65);
    is($screen_code, 1, q{_petscii_to_screen_code - converting PETSCII integer value to the screen code});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0x20);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
--------
--------
--------
--------
--------
--------
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($20)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0x3f);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--****--
-**--**-
-----**-
----**--
---**---
--------
---**---
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($3f)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0x40);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--****--
-**--**-
-**-***-
-**-***-
-**-----
-**---*-
--****--
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($40)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0x41);
    $capture->stop();
    my $petscii_a = <<PETSCII;
---**---
--****--
-**--**-
-******-
-**--**-
-**--**-
-**--**-
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($41)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0x5f);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
---*----
--**----
-*******
-*******
--**----
---*----
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($5f)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0x60);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
--------
--------
********
********
--------
--------
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($60)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0x7f);
    $capture->stop();
    my $petscii_a = <<PETSCII;
********
-*******
--******
---*****
----****
-----***
------**
-------*
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($7f)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0xa0);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
--------
--------
--------
--------
--------
--------
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($a0)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0xbf);
    $capture->stop();
    my $petscii_a = <<PETSCII;
****----
****----
****----
****----
----****
----****
----****
----****
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($bf)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0xc0);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
--------
--------
********
********
--------
--------
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($c0)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0xdf);
    $capture->stop();
    my $petscii_a = <<PETSCII;
********
-*******
--******
---*****
----****
-----***
------**
-------*
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($df)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0xe0);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
--------
--------
--------
--------
--------
--------
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($e0)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0xfe);
    $capture->stop();
    my $petscii_a = <<PETSCII;
****----
****----
****----
****----
--------
--------
--------
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($fe)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    write_petscii_char(*STDOUT, 0xff);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
--------
------**
--*****-
-***-**-
--**-**-
--**-**-
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($ff)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    set_petscii_write_mode('shifted');
    write_petscii_char(*STDOUT, ascii_to_petscii('a'));
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
--------
--****--
-----**-
--*****-
-**--**-
--*****-
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out shifted PETSCII character byte ('a')});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    set_petscii_write_mode('shifted');
    write_petscii_char(*STDOUT, ascii_to_petscii('A'));
    $capture->stop();
    my $petscii_a = <<PETSCII;
---**---
--****--
-**--**-
-******-
-**--**-
-**--**-
-**--**-
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out shifted PETSCII character byte ('A')});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    set_petscii_write_mode('shifted');
    write_petscii_char(*STDOUT, ascii_to_petscii('?'));
    $capture->stop();
    my $petscii_a = <<PETSCII;
--****--
-**--**-
-----**-
----**--
---**---
--------
---**---
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out shifted PETSCII character byte ('?')});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    set_petscii_write_mode('shifted');
    write_petscii_char(*STDOUT, 0x40);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--****--
-**--**-
-**-***-
-**-***-
-**-----
-**---*-
--****--
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out shifted PETSCII integer code ($40)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    set_petscii_write_mode('shifted');
    write_petscii_char(*STDOUT, 0x41);
    $capture->stop();
    my $petscii_a = <<PETSCII;
--------
--------
--****--
-----**-
--*****-
-**--**-
--*****-
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out shifted PETSCII integer code ($41)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    set_petscii_write_mode('shifted');
    write_petscii_char(*STDOUT, 0x61);
    $capture->stop();
    my $petscii_a = <<PETSCII;
---**---
--****--
-**--**-
-******-
-**--**-
-**--**-
-**--**-
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out shifted PETSCII integer code ($61)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    set_petscii_write_mode('shifted');
    write_petscii_char(*STDOUT, 0xc1);
    $capture->stop();
    my $petscii_a = <<PETSCII;
---**---
--****--
-**--**-
-******-
-**--**-
-**--**-
-**--**-
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($c1)});
}
#########################
{
    my $capture = IO::Capture::Stdout->new();
    $capture->start();
    set_petscii_write_mode('shifted');
    write_petscii_char(*STDOUT, 0xda);
    $capture->stop();
    my $petscii_a = <<PETSCII;
-******-
-----**-
----**--
---**---
--**----
-**-----
-******-
--------
PETSCII
    my $captured_text = join q{}, $capture->read;
    is($captured_text, $petscii_a, q{write_petscii_char - print out unshifted PETSCII integer code ($da)});
}
#########################
{
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    my $petscii_string = ascii_to_petscii('gąszcz');
    $capture->stop();
    like($capture->read, qr/^\QInvalid ASCII code at position 2 of converted text string: "0xc4" (convertible codes include bytes between 0x00 and 0x7f)\E/, q{ascii_to_petscii - warns on passing invalid ASCII byte code});
}
#########################
{
    my $petscii_string = ascii_to_petscii('leszcz');
    my $ascii_string = petscii_to_ascii($petscii_string);
    is($ascii_string, q{leszcz}, q{ascii_to_petscii - convert an ASCII string to a PETSCII string});
}
#########################
{
    my $petscii_string = ascii_to_petscii('A');
    my $ascii_string = petscii_to_ascii($petscii_string);
    is($ascii_string, q{A}, q{ascii_to_petscii - convert an ASCII charcter to a PETSCII character});
}
#########################
{
    my $capture = IO::Capture::Stderr->new();
    $capture->start();
    my $petscii_string = join q{}, map { chr hex $_ } qw/41 42 43 61 62 63 81 82 83/;
    my $ascii_string = petscii_to_ascii($petscii_string);
    $capture->stop();
    like($capture->read, qr/^\QInvalid PETSCII code at position 7 of converted text string: "0x81" (convertible codes include bytes between 0x00 and 0x7f)\E/, q{ascii_to_petscii - warns on passing invalid ASCII byte code});
}
#########################
{
    my $petscii_string = join q{}, map { chr hex $_ } qw/41 42 43 61 62 63/;
    my $ascii_string = petscii_to_ascii($petscii_string);
    is($ascii_string, q{abcABC}, q{petscii_to_ascii - convert a PETSCII string to an ASCII string});
}
#########################
{
    my $petscii_string = chr hex q{7a};
    my $ascii_string = petscii_to_ascii($petscii_string);
    is($ascii_string, q{Z}, q{petscii_to_ascii - convert a PETSCII character to an ASCII character});
}
#########################
