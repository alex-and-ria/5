module test();

  reg in1;
  reg in2;
  wire out;
  // Инстанциировать тестируемый модуль
  xor under_test(out, in1, in2);

  initial begin
      in1 = 0;
      in2 = 0;
    #1000 $check(out);

      in1 = 1;
      in2 = 0;
    #1000 $check(out);

      in1 = 0;
      in2 = 1;
    #1000 $check(out);

      in1 = 1;
      in2 = 1;
    #1000 $check(out);

    $finish;
  end // initial
 	  
endmodule

