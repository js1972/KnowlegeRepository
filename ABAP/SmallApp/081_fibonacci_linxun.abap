*&---------------------------------------------------------------------*
*& Report  Z_FIBO
*&
*&---------------------------------------------------------------------*
*&
*TODO: Jerry can send Xun about new implementation on 2016-12-4 21:17PM - aircraft from Germany to China
*&---------------------------------------------------------------------*

REPORT Z_FIBO.
PARAMETERS: N type i,
            v1 RADIOBUTTON GROUP v default 'X',
            v2 RADIOBUTTON GROUP v.

data: f type i,
      t type i.

data: product_guid type comm_product-product_guid.

get run time field t.
case 'X'.
  when v1. perform fibonacci using n changing f.
  when v2. perform fibonacci_2 using n changing f.
endcase.
write: / 'Fibonacci(', n, ') =', f.
get run time field t.
write: / 'Runtime', t, 'microseconds'.

*&---------------------------------------------------------------------*
*&      Form  fibonacci
*&---------------------------------------------------------------------*
form fibonacci using in type i
               changing fib type i.
  data: f_1 type i, f_2 type i,
        n_1 type i, n_2 type i.
  case in.
    when 0. fib = 1.
    when 1. fib = 1.
    when others.
      n_1 = in - 1.
      n_2 = in - 2.
      perform fibonacci using n_1 changing f_1.
      perform fibonacci using n_2 changing f_2.
      fib = f_1 + f_2.
  endcase.
endform.                    "fibonacci

*&---------------------------------------------------------------------*
*&      Form  fibonacci_2
*&---------------------------------------------------------------------*
form fibonacci_2 using in type i
                 changing fib type i.
  data: f_1 type i, f_2 type i,
        n_1 type i, n_2 type i,
        l type i.
  data: fibo type table of i.
  append 1 to fibo. " fibonacci(0)
  append 1 to fibo. " fibonacci(1)
    n_1 = 1.
    n_2 = 2.
  l = in - 1.
  do l times.
    read table fibo index n_1 into f_1.
    read table fibo index n_2 into f_2.
    fib = f_1 + f_2.
    add 1 to n_1. add 1 to n_2.
    append fib to fibo.
  enddo.
endform.                    "fibonacci_2