report z.

INCLUDE ole2incl.

DATA: ole   TYPE ole2_object,
      voice TYPE ole2_object,
      text  TYPE string.

text = 'With the advent of ES6 (referred to as ES2015 from here on)';
DATA: it_tline TYPE STANDARD TABLE OF tline.

CREATE OBJECT voice 'SAPI.SpVoice'.

CALL METHOD OF voice 'Speak' = ole
   EXPORTING #1 = text.
