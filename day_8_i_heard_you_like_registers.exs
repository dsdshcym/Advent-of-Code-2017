# TODO: extract separate module to handle Register operations like init, update
# TODO: parse value_str and comp_value_str as early as possible
# TODO: extract Comparor, Executor

defmodule Registers do
  def largest(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, registers -> run(line, registers) end)
    |> largest_value()
  end

  def largest_ever(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, 0}, fn line, {registers, largest} ->
      new_registers = run(line, registers)
      current_largest = largest_value(new_registers)
      new_largest = if current_largest > largest, do: current_largest, else: largest
      {new_registers, new_largest}
    end)
    |> elem(1)
  end

  defp largest_value(registers) do
    registers
    |> Map.values()
    |> Enum.max()
  end

  defp run(instruction, registers) when is_binary(instruction) do
    instruction
    |> String.split()
    |> operate(registers)
  end

  defp operate([target_reg, op, value_str, "if", cond_reg, comp_op, comp_value_str], registers) do
    safe_registers =
      registers
      |> Map.put_new(target_reg, 0)
      |> Map.put_new(cond_reg, 0)

    if compare(cond_reg, comp_op, comp_value_str, safe_registers) do
      execute(target_reg, op, value_str, safe_registers)
    else
      safe_registers
    end
  end

  defp compare(cond_reg, comp_op, comp_value_str, registers) when is_binary(comp_value_str) do
    compare(cond_reg, comp_op, String.to_integer(comp_value_str), registers)
  end

  defp compare(cond_reg, comp_op, comp_value, registers) do
    do_compare(Map.get(registers, cond_reg), comp_op, comp_value)
  end

  defp do_compare(a, "==", b), do: a == b
  defp do_compare(a, "<", b), do: a < b
  defp do_compare(a, "<=", b), do: a <= b
  defp do_compare(a, ">", b), do: a > b
  defp do_compare(a, ">=", b), do: a >= b
  defp do_compare(a, "!=", b), do: a != b

  defp execute(target_reg, op, value_str, registers) when is_binary(value_str) do
    execute(target_reg, op, String.to_integer(value_str), registers)
  end

  defp execute(target_reg, "inc", value, registers) do
    Map.update(registers, target_reg, value, &(&1 + value))
  end

  defp execute(target_reg, "dec", value, registers) do
    Map.update(registers, target_reg, -value, &(&1 - value))
  end
end

ExUnit.start()

defmodule RegistersTest do
  use ExUnit.Case

  @input """
  sd dec 441 if k != 0
  lp dec 419 if mxn >= 7
  w inc -592 if icg >= -9
  a dec -29 if q <= 9
  kt dec 486 if ms != 8
  kt inc -841 if kt > -488
  rz inc -592 if m <= 1
  xtz dec 780 if lp < 9
  iox dec 804 if icg != 6
  lp inc 360 if i == 9
  f dec -570 if gi >= 7
  um inc 87 if q != 4
  kt dec -242 if rz != -595
  j inc -154 if db != 0
  giq dec 728 if iox > -811
  a dec -9 if xtz > -781
  lp inc -261 if ms > 2
  w inc -816 if hey > -1
  mxn inc 680 if ms >= -9
  q inc -777 if w < -1400
  wm dec -353 if q == -774
  q inc 414 if hey == 0
  xdl inc 488 if kt != -1075
  gus dec -136 if fxx != -7
  f dec 852 if hey >= 10
  j inc 531 if ms <= -9
  km dec 231 if xdl >= 487
  fxx dec 579 if iox == -804
  km dec 23 if kt != -1076
  fxx inc -845 if xtz != -773
  mxn dec 335 if fxx != -1432
  q dec 184 if f == 0
  wm dec -330 if f == 0
  iox dec 677 if mxn != 339
  mxn inc -429 if hey < 1
  rz dec 101 if hey == 8
  k inc 17 if db == 0
  gus inc -328 if iox == -1481
  a inc 657 if rz <= -584
  wm dec -365 if rz < -590
  m inc -710 if w < -1399
  kt inc -246 if wm != 698
  w dec 976 if fxx >= -1431
  giq inc 319 if hey >= -5
  iox inc -563 if xdl < 495
  xdl dec -349 if f >= -9
  sd inc -296 if q >= -555
  xdl inc 406 if cl >= -2
  f inc 966 if hey >= -6
  lp dec -838 if iox > -2054
  k dec -674 if q < -542
  i inc -23 if k < 692
  mxn inc -221 if sd != -302
  mxn inc -830 if mxn > -309
  km inc -283 if db > -7
  icg inc 365 if xdl > 1234
  q inc -23 if m < -702
  wm dec -507 if rz < -582
  j inc -501 if gi != -10
  um inc 274 if a > 689
  db inc 814 if xdl != 1250
  fxx dec -172 if db != 822
  wm dec 581 if kt <= -1323
  gi dec -715 if kt >= -1339
  f inc -209 if i >= -31
  q inc 933 if fxx > -1246
  mxn dec -227 if gi > 713
  fxx dec -112 if xdl <= 1252
  hey dec -998 if xtz >= -781
  lp dec -743 if ms <= 4
  icg dec -581 if fxx > -1149
  gus inc 725 if k != 698
  icg dec 156 if kt != -1339
  gus dec 961 if i > -32
  giq dec -992 if kt <= -1327
  m inc -477 if xdl >= 1240
  db dec -258 if gus <= -424
  wm inc -72 if gi > 713
  i dec 923 if lp == 1581
  m inc -221 if iox == -2044
  j inc 410 if m < -1402
  kt inc 838 if a == 685
  i dec 528 if gi < 712
  iox dec -823 if i >= -952
  a dec -705 if icg > 799
  gi dec -538 if db > 1079
  xdl inc -507 if q > -571
  rz inc 37 if km > -546
  fxx dec -718 if ms <= -2
  xdl inc -742 if cl < 4
  q dec 591 if wm > 542
  a dec 100 if db != 1072
  fxx dec -392 if giq >= 579
  j inc 991 if i >= -942
  m inc 311 if sd != -296
  icg inc -286 if db != 1075
  m inc 906 if rz == -555
  um inc 150 if hey == 993
  rz inc -637 if fxx < -746
  ms dec 779 if f >= 751
  gus inc 928 if j != -100
  rz dec 769 if sd < -292
  xdl inc -556 if gus <= 505
  rz inc -94 if j < -82
  mxn dec -763 if cl == 0
  xdl dec -693 if gus <= 502
  db inc -879 if kt <= -1339
  w dec 651 if hey > 991
  um dec -898 if giq == 583
  xdl dec 501 if hey > 998
  wm dec 746 if lp < 1587
  iox inc 915 if um > 1251
  a inc 573 if q >= -1165
  j dec -459 if m <= -512
  km dec -601 if xdl >= 131
  km dec 801 if f >= 756
  ms inc 318 if j < -91
  hey dec -768 if i <= -945
  f inc -982 if xdl < 134
  i inc 210 if iox < -305
  icg inc -838 if xtz >= -784
  mxn dec 901 if f == -225
  m inc 601 if i <= -733
  iox inc -863 if cl >= -5
  ms dec -474 if db >= 1069
  xtz dec 708 if um >= 1253
  lp dec 0 if xdl < 130
  k inc -476 if sd <= -291
  um dec 475 if hey != 1756
  q inc 178 if k <= 215
  km dec 244 if a >= 1265
  j dec 485 if k < 209
  icg inc 429 if um >= 784
  ms inc -881 if kt > -1341
  cl inc -75 if iox < -1176
  icg dec -72 if gi == 715
  i inc 714 if lp >= 1572
  rz inc -881 if j >= -96
  ms dec -453 if i <= -29
  giq dec -500 if sd != -305
  sd dec -78 if lp != 1572
  a inc 313 if db == 1072
  w dec 97 if q == -978
  gus dec -203 if f != -225
  xdl dec -894 if j < -88
  q inc 71 if k != 213
  um dec -242 if wm > -207
  kt dec -997 if sd != -215
  cl dec 643 if lp != 1587
  hey inc -564 if fxx == -748
  ms dec 639 if m != 95
  ms dec 131 if w <= -3026
  xdl dec 241 if w != -3032
  mxn inc 404 if i == -28
  giq dec 111 if xdl >= 789
  wm inc 93 if j <= -88
  xdl inc 318 if um >= 1026
  gi dec -766 if a < 1587
  mxn inc 212 if w > -3040
  f dec -601 if giq == 1084
  m dec 135 if kt >= -334
  a dec -471 if rz >= -2940
  cl dec -379 if giq != 1080
  w inc -834 if db < 1077
  km inc -515 if f >= -226
  i inc 133 if a > 2043
  gus dec -368 if gi >= 1476
  db inc -629 if fxx > -758
  km inc -807 if a != 2052
  j dec -129 if cl > -267
  gi dec -443 if m <= -35
  kt dec -355 if sd != -218
  mxn inc -734 if xtz == -1488
  icg inc 468 if m == -34
  m inc 896 if iox <= -1168
  xdl inc -763 if j < 39
  db inc -51 if xdl >= 337
  sd dec 688 if icg >= 167
  w inc 307 if gi >= 1924
  ms inc 190 if xdl >= 331
  k inc 869 if fxx >= -750
  mxn inc -772 if ms >= -1771
  f inc -303 if q == -922
  kt dec 99 if ms < -1757
  j dec -733 if sd < -904
  wm inc -808 if gi <= 1933
  q dec -671 if i != 112
  cl inc -790 if xdl >= 330
  icg inc -617 if ms > -1774
  w inc 529 if xdl > 333
  w inc -413 if wm < -907
  db inc 780 if xdl > 330
  xtz inc -535 if um <= 1025
  mxn inc 415 if db > 1165
  xtz inc 170 if db != 1169
  k dec -365 if k <= 1091
  giq inc -695 if q < -233
  db inc -991 if a > 2057
  k dec 543 if fxx == -748
  kt inc 673 if hey <= 1209
  gi inc -23 if mxn <= -1917
  m inc -567 if sd > -916
  m dec -269 if wm == -912
  kt dec 601 if db != 1180
  km dec -781 if kt == -351
  rz inc -296 if wm != -912
  um inc 4 if gus != 874
  um inc -876 if q < -231
  gi dec -744 if xtz < -1320
  j inc -101 if q <= -236
  kt inc -959 if xtz == -1318
  icg dec 9 if m == 562
  kt inc -412 if gus > 867
  fxx dec 394 if gus > 867
  fxx dec 105 if xtz == -1318
  a dec -533 if giq != 396
  km dec -864 if um != 147
  mxn dec -240 if i != 114
  m inc -830 if km != -628
  iox inc 160 if mxn != -1690
  k inc 966 if j > 679
  xtz inc 482 if cl <= -1050
  f inc -430 if fxx < -1253
  sd inc 138 if sd > -915
  giq dec 736 if xtz == -836
  f dec 780 if ms >= -1767
  wm inc -362 if kt <= -1731
  um dec -195 if xtz >= -838
  um dec 888 if i >= 107
  i dec 754 if gus != 868
  hey inc -518 if kt <= -1726
  iox inc 843 if hey > 676
  ms dec -46 if a < 2587
  mxn inc 288 if gus >= 864
  gus inc -643 if mxn < -1393
  um inc 457 if rz >= -2936
  um dec -976 if xtz == -836
  m dec 783 if fxx > -1254
  gi inc -63 if m <= -1043
  lp dec -244 if cl > -1062
  sd inc 908 if km >= -637
  km inc -725 if kt <= -1731
  j dec -20 if k == 906
  wm dec -596 if kt >= -1740
  xtz dec 133 if km <= -1355
  db inc -792 if icg != -466
  db dec -851 if lp != 1835
  cl dec 707 if f > -1012
  iox dec 246 if iox >= -170
  um dec 719 if ms == -1720
  xtz dec -216 if icg != -464
  km dec 776 if w <= -3446
  j dec 388 if xdl != 339
  j dec 776 if kt == -1732
  mxn dec 615 if cl == -1761
  i inc 579 if gus < 226
  i inc -172 if xdl < 341
  ms inc 720 if lp < 1825
  ms dec -590 if hey < 690
  iox dec -781 if gus < 231
  mxn inc -145 if a >= 2577
  q inc -885 if f <= -1013
  xtz inc -148 if a != 2593
  km inc -586 if fxx < -1239
  um inc -988 if kt < -1724
  k dec -852 if xtz != -891
  j inc -365 if m != -1050
  gus inc -679 if cl != -1760
  um inc -342 if icg != -455
  hey inc -807 if mxn == -2157
  w dec 759 if w != -3439
  ms inc -328 if gus >= -455
  gi inc -179 if iox == 369
  ms inc 930 if giq != -345
  fxx inc 959 if giq == -338
  km dec -605 if db <= 1226
  um dec 954 if gus == -460
  f inc -325 if giq < -341
  cl dec -95 if cl <= -1752
  hey dec 825 if sd < 141
  db dec -608 if sd >= 139
  giq inc 141 if lp > 1821
  a dec 824 if km <= -2715
  k inc 982 if db < 1840
  k dec -6 if giq != -213
  xtz dec -59 if kt <= -1731
  fxx dec -589 if a == 1761
  m inc 874 if rz == -2936
  m dec 241 if xtz == -838
  gus dec 512 if w > -4208
  mxn inc 651 if gus == -973
  lp inc -553 if hey == -948
  giq inc 252 if lp > 1263
  km dec -360 if a == 1761
  giq inc -504 if a != 1770
  kt inc -815 if um <= -1146
  lp dec 343 if gi >= 1652
  w dec 6 if lp <= 937
  gus dec 806 if ms > -534
  q dec 262 if f > -1335
  rz dec -959 if sd <= 141
  w dec -958 if mxn == -2157
  gus inc 530 if xdl > 333
  lp dec -30 if hey > -949
  lp dec 345 if q != -509
  i inc 509 if km > -2363
  rz inc -576 if um == -1155
  km inc 622 if iox > 367
  k dec -833 if ms != -527
  um dec 586 if i == 1027
  q inc -724 if rz == -2553
  cl dec -372 if f <= -1330
  cl dec -944 if j > -442
  j dec 674 if hey != -958
  q inc -830 if j != -1135
  cl dec 594 if um < -1749
  gi dec -991 if q > -2066
  kt dec -528 if giq >= -465
  iox inc -291 if a > 1759
  q dec -395 if f != -1330
  um dec 244 if cl <= -1285
  a dec 961 if um < -1988
  iox inc -321 if w == -3253
  lp dec -307 if iox < -241
  m dec -188 if mxn == -2157
  um dec -481 if icg <= -450
  gi dec 303 if cl < -1294
  mxn dec -791 if wm != -684
  kt dec -368 if sd != 149
  mxn dec -783 if sd < 141
  gi dec 864 if m == 11
  gus dec -17 if w == -3253
  w dec 499 if giq > -464
  xtz inc 659 if q > -2067
  wm inc 572 if kt != -1654
  xtz dec -287 if xtz != -191
  sd inc 763 if kt <= -1658
  xdl inc 830 if gus == -1225
  icg inc 508 if km == -1737
  gi inc 756 if rz == -2560
  xtz inc 983 if km <= -1734
  w inc 717 if xtz > 1085
  q dec 52 if w < -3030
  xdl inc -373 if f <= -1321
  w dec -544 if icg > 56
  gus inc -120 if km > -1741
  mxn dec -16 if hey <= -947
  wm dec 591 if mxn != -576
  gus inc -355 if kt <= -1644
  xdl inc 898 if fxx <= -650
  f dec 71 if m != 11
  xtz dec 902 if fxx > -663
  kt dec -576 if db != 1831
  rz inc 465 if fxx < -650
  a dec 342 if fxx >= -666
  k inc 293 if cl != -1286
  iox dec 791 if db == 1839
  a dec 125 if kt != -1071
  gi dec 852 if xtz == 185
  f inc 982 if sd == 133
  mxn dec -426 if sd <= 146
  gus inc -100 if xdl <= 1696
  um inc 872 if xtz != 182
  db dec -10 if db < 1843
  q inc 209 if lp >= 920
  k inc -338 if hey >= -950
  m inc -601 if wm < -695
  w dec 725 if xdl >= 1694
  wm inc -913 if q >= -1901
  fxx inc 986 if sd <= 144
  a dec 329 if m == -590
  xtz inc 80 if q < -1893
  gus inc 234 if fxx == 328
  ms inc 110 if giq < -451
  gus dec -969 if sd != 134
  um dec 806 if ms <= -417
  gus dec -458 if icg < 53
  cl dec -272 if fxx > 326
  k inc -212 if sd != 143
  xtz dec 109 if fxx <= 324
  mxn dec 302 if m >= -599
  lp inc -240 if giq <= -451
  m dec -58 if wm != -1618
  xtz dec -178 if gus == -139
  giq inc -132 if xdl != 1694
  w inc -149 if a >= 962
  f inc -512 if lp <= 690
  lp dec -84 if sd < 147
  cl inc 657 if db <= 1851
  m inc -180 if hey == -948
  sd inc -711 if a < 974
  ms inc -905 if j != -1134
  f inc -852 if mxn >= -451
  lp inc 818 if i == 1027
  w dec -407 if wm <= -1610
  m dec -298 if gi > 926
  gi inc -17 if sd != -564
  ms inc 891 if kt != -1075
  xdl inc -498 if fxx != 337
  kt dec 153 if lp == 1575
  db inc -565 if f < -2690
  lp inc 812 if um <= -1438
  fxx inc 151 if um != -1429
  fxx dec 484 if km < -1732
  q inc 130 if f == -2690
  lp dec 926 if icg != 58
  giq dec -378 if k >= 3321
  cl dec 136 if ms == -1323
  xdl dec -889 if w != -3502
  hey dec 540 if hey == -948
  a dec 796 if xdl >= 1189
  xtz dec 197 if kt < -1066
  i dec 328 if db == 1284
  giq dec -697 if hey > -1482
  f inc -985 if icg != 51
  gi inc 128 if f > -3689
  j dec 638 if i != 699
  mxn inc 300 if icg < 55
  icg inc -846 if q <= -1900
  icg dec -845 if giq > -86
  cl dec 502 if hey < -1482
  db inc -18 if hey != -1483
  giq inc -398 if wm < -1615
  xtz inc -724 if gus > -146
  um inc -761 if gus >= -137
  gi dec 423 if mxn <= -146
  xtz dec -632 if ms >= -1326
  gi dec 990 if i == 693
  xtz dec 292 if i == 699
  q inc 881 if xtz >= -143
  xdl dec -25 if a <= 175
  f dec -599 if iox >= -1036
  giq dec -502 if gus == -139
  xdl dec 235 if gus >= -139
  q inc 704 if wm <= -1610
  ms inc 693 if i == 699
  k inc 407 if ms != -627
  f dec 107 if iox <= -1029
  xtz inc -328 if w != -3502
  j dec -474 if xdl < 994
  gus dec 82 if fxx != -12
  db dec -913 if xtz >= -143
  iox dec -932 if gus != -230
  giq inc -74 if q > -316
  ms inc -711 if gi != 1039
  w dec -29 if q >= -315
  um inc -851 if xtz == -141
  f inc -816 if ms <= -1348
  hey inc 813 if lp > 1468
  sd dec 483 if icg != 48
  w dec -199 if db <= 2181
  q inc -846 if sd != -572
  db inc -134 if k <= 3732
  um dec -185 if mxn > -145
  rz inc 559 if a < 174
  cl inc 650 if f != -3190
  gi inc 785 if cl >= -343
  w inc -227 if lp >= 1468
  gus inc -437 if wm < -1608
  kt inc -301 if w < -3499
  k dec -873 if km < -1736
  xdl dec -262 if q < -1155
  f dec 325 if mxn >= -149
  wm inc 523 if km < -1736
  gus dec -643 if db <= 2053
  gus dec 998 if iox > -95
  icg inc 774 if q < -1160
  k inc 789 if a > 159
  fxx dec 447 if xtz <= -133
  m inc -730 if rz <= -1526
  mxn dec -825 if cl > -346
  xtz inc 846 if sd > -576
  mxn inc 128 if cl < -352
  cl dec 99 if xtz <= 704
  lp dec -537 if ms >= -1341
  giq dec 784 if w == -3501
  iox inc 410 if giq <= -437
  f dec 314 if iox <= 317
  kt inc 520 if a == 169
  wm inc -419 if km >= -1740
  icg dec 900 if fxx != -450
  hey dec 564 if hey <= -670
  um inc 653 if lp < 2016
  hey dec 835 if fxx <= -447
  giq dec 542 if giq == -433
  gus dec 320 if cl > -354
  icg inc 75 if i > 695
  iox inc -949 if j <= -649
  q inc 0 if ms == -1341
  um dec 180 if rz != -1538
  i inc 534 if rz >= -1536
  i inc -316 if fxx == -452
  rz dec 225 if icg <= 2
  gus inc -416 if km != -1727
  icg inc -325 if m >= -1150
  rz dec 892 if gus < -742
  k inc -832 if j > -657
  wm inc -10 if gus <= -752
  f dec 179 if rz < -2644
  q inc 817 if kt > -859
  fxx inc 501 if xtz < 712
  m inc 111 if kt < -862
  ms dec -896 if gus != -749
  kt dec -925 if kt >= -862
  fxx inc -713 if cl <= -355
  xdl dec -120 if a == 172
  a dec -757 if hey != -2073
  gus inc 127 if mxn != -12
  xdl inc -627 if f == -3995
  kt dec 832 if lp < 2004
  w dec 208 if kt > 61
  kt dec 378 if lp >= 1998
  cl dec -371 if xdl > 1249
  f dec 708 if i < 927
  db dec 602 if ms > -443
  cl dec 247 if f > -4707
  um dec -394 if gi != 1040
  j dec 190 if giq >= -440
  gi inc 560 if q == -347
  xdl inc -601 if gus >= -630
  k dec 934 if iox == -641
  m inc -672 if icg >= -334
  w dec 104 if xdl != 647
  lp dec 36 if icg >= -329
  mxn dec 768 if m >= -1821
  f dec 555 if k == 3625
  w dec 440 if q >= -353
  lp dec -83 if kt != -316
  hey dec -168 if db != 2042
  giq dec 460 if xtz == 708
  fxx dec 446 if icg <= -325
  icg dec -22 if xtz != 717
  ms dec 920 if j != -841
  hey inc 213 if db < 2053
  mxn dec 862 if w < -4150
  rz dec 873 if xdl <= 656
  gi inc -584 if lp > 2047
  kt inc -29 if um <= -385
  m inc -883 if xtz < 715
  j inc 850 if iox == -641
  xdl dec 738 if w > -4154
  icg dec -851 if kt <= -329
  db inc -437 if ms > -449
  kt inc 280 if xtz > 702
  iox dec 924 if giq <= -899
  m dec 453 if cl < -344
  fxx inc -543 if i > 914
  rz inc 402 if f > -5269
  iox dec -260 if giq >= -900
  km dec -971 if sd >= -578
  wm inc 193 if k == 3630
  xdl dec -416 if a != 932
  lp inc 213 if icg == 545
  um inc 864 if wm <= -1516
  lp dec 343 if fxx <= -943
  rz inc 657 if kt > -50
  kt dec -253 if xdl <= 328
  km inc 256 if mxn > -781
  hey inc 856 if k == 3625
  gus inc 266 if f < -5264
  rz dec -139 if m <= -3151
  hey dec -669 if db == 1603
  gi inc -452 if ms == -445
  kt inc 123 if mxn == -783
  f inc -656 if sd > -562
  m inc -479 if i > 915
  um inc -288 if sd == -571
  giq dec -68 if gi == 9
  fxx dec -867 if fxx != -940
  um inc 80 if m > -3636
  i dec 980 if j < 9
  lp inc -932 if km < -764
  cl inc 387 if mxn != -788
  wm dec -492 if km != -766
  km inc 571 if m > -3634
  kt inc 903 if q >= -340
  wm inc 852 if k < 3616
  um dec -210 if m < -3629
  j inc -136 if m < -3623
  j dec -575 if i != 908
  sd inc 762 if xdl == 325
  gi inc -933 if kt != 314
  giq inc 272 if fxx < -939
  um inc -279 if iox <= -386
  xtz dec 303 if f < -5258
  xtz dec 344 if iox != -378
  giq dec -384 if f < -5264
  f inc -698 if mxn <= -778
  rz inc -185 if q <= -342
  um dec 272 if db <= 1613
  rz inc -650 if q <= -347
  xtz dec -621 if q <= -340
  kt inc 497 if sd < 200
  gus dec -786 if km < -203
  um dec 584 if a != 926
  hey dec 467 if xdl <= 318
  ms inc -975 if j == 448
  rz inc 763 if w <= -4144
  cl dec 923 if i >= 915
  km inc -294 if fxx >= -942
  fxx dec 218 if ms != -1420
  q inc 671 if gus < -350
  xdl dec 652 if i >= 913
  xtz dec -657 if gus > -367
  km dec 316 if j != 457
  wm dec 664 if fxx <= -932
  iox dec 463 if gus != -359
  hey inc -254 if fxx <= -940
  cl inc -684 if q > 317
  rz dec -287 if xtz < 1348
  lp dec 315 if lp != 1340
  hey dec -685 if q >= 325
  kt dec -360 if icg <= 553
  a inc 834 if um >= -646
  m inc -91 if sd < 183
  a dec 37 if k != 3617
  a inc -306 if sd != 201
  k dec 822 if q <= 327
  iox inc -885 if iox >= -850
  kt inc -835 if rz == -2113
  cl dec -99 if a < 586
  cl dec 635 if w != -4141
  kt inc -938 if giq == -173
  sd dec 599 if iox != -1720
  ms dec -484 if j != 448
  wm inc 669 if fxx == -945
  iox inc -633 if sd <= -402
  i dec -774 if f >= -5963
  f inc -783 if um < -646
  km inc 6 if xtz > 1333
  gus inc -986 if a == 583
  iox inc -233 if um <= -651
  xtz dec -857 if w != -4149
  wm inc -791 if a < 584
  j dec -41 if cl <= -2111
  xdl inc 77 if rz > -2123
  xdl inc -983 if ms != -1416
  fxx dec 247 if sd == -408
  k inc -362 if k > 2804
  xdl inc 13 if iox >= -2595
  db inc 473 if um <= -654
  w inc 307 if w > -4152
  xdl dec -237 if a <= 584
  wm inc 366 if giq == -173
  j dec 111 if i != 917
  k dec 790 if w != -3848
  sd dec -841 if wm == -2595
  i inc -538 if xdl == -989
  f dec 583 if rz > -2114
  xtz inc -886 if kt <= -590
  ms inc 151 if mxn == -783
  q dec -585 if fxx == -1184
  j dec -102 if km == -799
  xdl dec 504 if sd == 433
  fxx inc -208 if db > 2078
  m dec 471 if q >= 323
  icg inc -296 if i <= 919
  rz dec -601 if mxn > -791
  gus dec -870 if gi > -925
  um dec -171 if gi >= -927
  f inc 969 if gi != -932
  j dec 78 if xdl <= -1481
  m dec 115 if lp != 1019
  km inc 911 if ms != -1267
  gi inc 798 if i <= 920
  iox dec -780 if km < 122
  cl dec 670 if xdl > -1492
  gus inc 231 if kt != -602
  giq dec 584 if k <= 2021
  j dec -142 if k != 2020
  a inc 905 if xdl == -1487
  giq inc -1 if k > 2012
  j inc -123 if sd != 433
  a dec -615 if ms >= -1270
  q inc 848 if ms == -1269
  kt dec -69 if w < -3838
  fxx dec -676 if i > 926
  iox dec 980 if gi > -131
  fxx dec -716 if giq != -758
  fxx dec 937 if sd > 433
  sd inc 414 if i != 914
  cl inc -625 if giq <= -757
  gus dec 306 if fxx != -1390
  q inc 228 if lp != 1010
  ms inc 340 if gus == -549
  cl inc -185 if xtz == 461
  m dec -550 if f == -6363
  fxx dec 73 if lp >= 1019
  ms inc 651 if w != -3842
  giq inc 155 if xtz > 450
  wm dec -41 if icg < 253
  wm inc -535 if k != 2006
  j dec 181 if a >= 2094
  cl inc -70 if km <= 114
  i dec -910 if db < 2085
  mxn dec -616 if giq != -610
  ms inc 688 if lp <= 1019
  kt inc 264 if f == -6357
  gi inc -200 if xdl >= -1496
  rz dec -610 if km < 121
  w dec 82 if wm < -3085
  giq dec 136 if um != -483
  rz inc 804 if km < 121
  i dec 197 if um < -475
  cl dec 656 if ms == -241
  m inc 656 if w <= -3921
  lp inc -497 if gus > -557
  xtz inc 47 if w > -3926
  hey dec -130 if km <= 112
  gus inc 800 if gus > -555
  icg dec 229 if wm == -3089
  kt dec -746 if gi != -333
  xdl dec -365 if m == -2896
  gi dec 286 if j > 430
  wm inc 858 if q > 1393
  mxn dec 440 if iox >= -2798
  sd dec 651 if hey < -282
  um inc 135 if kt <= 220
  hey dec -639 if ms != -251
  lp dec 558 if q != 1393
  kt dec -264 if kt != 217
  sd inc -523 if k >= 2006
  k dec 938 if w <= -3917
  mxn inc -120 if um == -350
  giq inc -223 if icg > 16
  m dec 171 if xtz < 504
  um dec 850 if xdl == -1122
  iox inc 955 if km >= 118
  gi dec -910 if icg == 20
  db inc -39 if xdl > -1116
  mxn dec 481 if xtz > 491
  um dec 766 if iox >= -2798
  sd inc -103 if um != -1967
  q inc -673 if q <= 1403
  hey dec -471 if xdl == -1122
  j inc -818 if sd <= 212
  fxx dec -749 if ms > -238
  w inc 407 if xdl >= -1123
  mxn dec 138 if xtz >= 507
  rz dec 257 if db != 2071
  xdl dec 116 if lp > -38
  mxn inc -162 if xtz <= 495
  gi dec 669 if i < 1633
  gi dec 187 if ms == -251
  mxn dec 893 if xdl != -1229
  k inc 616 if i <= 1633
  xtz dec 881 if a <= 2105
  gus inc 732 if i != 1627
  kt inc 749 if a == 2103
  f inc -289 if rz <= -346
  um inc 919 if f < -6644
  wm inc -646 if m != -3067
  hey inc 1 if a != 2108
  xdl dec 725 if ms <= -238
  j dec -789 if k != 1695
  hey inc 317 if w < -3515
  kt inc 965 if gi >= -379
  wm inc 137 if a != 2101
  sd dec -783 if hey <= 1160
  gus dec -349 if um <= -1046
  ms inc -843 if sd == 1004
  k inc -298 if f >= -6661
  gus dec -15 if gi <= -365
  gus dec -411 if wm <= -2092
  cl inc 25 if icg != 30
  km inc 634 if m == -3067
  kt dec 856 if gus < 1766
  xdl inc -808 if fxx <= -1461
  xdl dec -883 if rz >= -358
  gus dec -311 if j > 1214
  sd dec 349 if xdl == -1888
  mxn dec -309 if j <= 1225
  giq dec 181 if ms >= -1087
  rz dec -951 if iox >= -2788
  k dec -824 if lp != -42
  fxx dec -984 if km <= 746
  mxn dec 333 if gus <= 2067
  fxx dec 742 if db >= 2078
  kt inc -367 if mxn > -1793
  i dec -853 if lp < -27
  kt dec -491 if wm < -2085
  ms inc 233 if wm != -2097
  i inc 729 if rz != -363
  ms dec 246 if km < 737
  xtz dec 455 if cl > -4106
  icg inc -755 if kt <= 1206
  wm dec -828 if mxn <= -1798
  giq inc 397 if xdl != -1888
  mxn dec 861 if cl != -4101
  fxx dec 406 if f <= -6653
  icg dec -101 if rz == -355
  gus dec -147 if cl <= -4101
  cl dec 717 if q > 728
  db dec -276 if m < -3061
  k dec -3 if sd > 651
  lp dec -357 if xtz < -827
  f dec -380 if lp <= 322
  cl inc -740 if gi > -368
  sd inc 744 if fxx >= -1221
  iox inc 39 if mxn != -2661
  fxx inc -569 if ms < -841
  j dec 19 if gus == 2216
  sd inc 826 if f < -6267
  cl dec -377 if f != -6272
  fxx dec 318 if icg >= -638
  db dec 638 if xdl == -1883
  q dec -923 if um >= -1055
  a inc 22 if q < 1656
  rz inc 129 if sd <= 1484
  db dec 408 if kt == 1199
  q inc -782 if iox <= -2750
  w dec 232 if fxx >= -2119
  gi dec -887 if km >= 738
  hey dec 35 if icg < -624
  xdl inc -379 if um > -1052
  hey inc -596 if icg != -638
  hey dec -945 if um >= -1047
  xdl dec -202 if k > 2219
  rz dec 76 if f < -6269
  xdl inc 289 if q <= 876
  rz inc 308 if kt >= 1190
  a inc -190 if lp != 317
  kt inc -195 if db >= 1944
  f dec 526 if q < 878
  wm dec -305 if xdl > -1777
  xdl dec -99 if k != 2215
  fxx inc 953 if wm == -1789
  hey dec 625 if rz == -1
  mxn dec 319 if mxn < -2644
  m dec 611 if f == -6798
  fxx dec -83 if icg < -639
  gi dec 567 if cl > -4830
  ms inc -95 if mxn < -2966
  um inc 862 if gus != 2215
  hey dec -341 if icg == -634
  iox dec 829 if f <= -6801
  giq dec 376 if kt == 1012
  lp dec -990 if um < -183
  iox inc -868 if kt >= 999
  iox dec -670 if f <= -6796
  fxx inc 895 if gus < 2209
  k inc -916 if q <= 873
  rz dec 646 if w >= -3747
  kt inc -807 if j == 1203
  fxx dec 568 if gi >= -43
  giq dec -966 if q < 877
  rz inc 250 if giq < -174
  iox inc -19 if i == 3212
  f inc -404 if k <= 1304
  gi dec -481 if kt >= 195
  giq dec -323 if gi < 424
  lp inc 873 if km >= 752
  icg dec 953 if um <= -182
  q dec 246 if db != 1942
  rz inc -987 if lp > 1307
  hey inc -728 if xtz <= -837
  fxx dec 743 if xtz != -843
  km dec 393 if km <= 740
  rz inc 635 if icg < -1578
  k dec -136 if km <= 742
  gus inc 715 if giq >= -185
  lp dec 782 if km >= 741
  ms dec -140 if sd != 1479
  iox inc -992 if sd != 1488
  wm inc 8 if ms >= -802
  giq dec 134 if xtz <= -830
  mxn dec 877 if xtz > -832
  lp inc -260 if ms > -815
  xdl inc 170 if w > -3742
  q inc -674 if gi != 434
  giq inc -760 if wm <= -1788
  km dec -96 if hey != 1802
  j inc 662 if fxx >= -1904
  gus dec 305 if a <= 1943
  db inc 881 if icg > -1583
  um inc -137 if rz >= -96
  mxn dec -755 if lp == 269
  lp inc -220 if hey > 1799
  cl inc 652 if xdl >= -1678
  gus inc -473 if a >= 1935
  k dec 80 if i != 3216
  gus inc 138 if xtz != -831
  mxn inc 654 if giq >= -1075
  xtz inc -677 if um >= -323
  cl inc -557 if hey >= 1807
  m dec 488 if lp == 49
  k inc -214 if q != -49
  k inc -584 if cl != -4727
  icg inc -423 if ms == -806
  gi dec -323 if fxx >= -1909
  ms dec -61 if giq != -1062
  wm dec 259 if q < -45
  f inc -634 if gi == 753
  iox inc 985 if gi > 750
  km dec -821 if db < 1950
  f inc 105 if gi < 763
  j inc -36 if q <= -44
  ms inc -244 if giq < -1063
  i dec 423 if cl == -4727
  kt dec 77 if sd == 1481
  db inc -779 if gi == 753
  gi dec -525 if iox <= -2985
  f dec 378 if rz != -86
  mxn dec 479 if km < 1671
  f inc -812 if kt > 118
  db inc -121 if kt < 128
  w inc 957 if mxn == -2042
  db inc -97 if mxn != -2052
  km inc 521 if q < -46
  a dec -669 if i >= 2783
  icg inc 47 if km > 2176
  gi inc 459 if gi != 760
  mxn dec 810 if hey >= 1803
  ms inc -896 if xtz != -1522
  fxx inc 331 if cl == -4727
  hey dec 104 if sd < 1482
  f dec -684 if f < -8923
  xtz dec 893 if giq > -1080
  um dec -749 if db < 962
  rz inc 823 if sd <= 1484
  a inc 4 if w > -2793
  cl dec -559 if a > 2614
  iox dec 116 if db <= 956
  cl dec -384 if gus == 2291
  lp inc 522 if kt > 118
  icg dec -250 if km <= 2186
  j inc -144 if mxn > -2843
  kt dec -682 if ms > -1891
  gi inc -320 if sd < 1489
  iox dec -955 if kt != 802
  mxn dec 949 if lp > 570
  mxn dec -84 if wm > -2050
  xtz dec 762 if kt == 802
  wm dec -74 if um != 422
  m inc -948 if gi >= 889
  w inc 90 if w != -2792
  j dec -516 if fxx <= -1568
  cl inc -457 if k <= 1232
  ms dec -288 if w != -2792
  ms inc 57 if db >= 946
  a dec -481 if w >= -2800
  icg dec -210 if ms != -1827
  giq inc 323 if a != 3098
  ms inc -646 if iox <= -3090
  mxn dec -390 if lp > 565
  db dec 634 if hey >= 1701
  iox inc 357 if w >= -2799
  hey inc 434 if icg != -1503
  um dec 763 if xtz == -3168
  giq dec 742 if m != -5115
  giq inc -645 if db < 318
  f inc -832 if ms == -2474
  xtz dec 921 if w > -2799
  f dec -259 if xtz <= -4086
  mxn dec -689 if ms == -2468
  kt inc -725 if iox != -2732
  sd inc -586 if rz <= 730
  w dec 94 if xdl > -1682
  lp inc -793 if km > 2185
  cl inc -764 if j < 2348
  lp dec 656 if fxx != -1577
  f dec -892 if db > 319
  i inc -441 if k <= 1230
  db dec 935 if q == -49
  q dec -926 if xtz > -4094
  q inc 729 if fxx == -1572
  lp inc 115 if k != 1233
  j dec -252 if mxn == -3318
  w inc 695 if gi <= 891
  j dec -721 if gi < 899
  sd dec -132 if sd == 896
  cl inc 856 if icg == -1503
  giq inc -142 if k >= 1218
  iox inc -328 if db <= -617
  db inc -199 if wm >= -1981
  km dec -364 if j == 3066
  cl dec -659 if sd >= 891
  xtz inc -207 if giq == -1632
  cl inc 928 if i <= 2339
  giq inc -897 if km != 2544
  mxn inc -61 if xdl > -1679
  f inc 953 if lp >= 30
  f dec -450 if giq > -2535
  w dec -962 if kt >= 68
  gi inc 317 if km < 2556
  kt dec -271 if k >= 1231
  iox dec 238 if i <= 2352
  xtz inc -840 if ms <= -2467
  giq dec 905 if f >= -8097
  kt dec 484 if icg <= -1502
  lp dec 675 if km >= 2539
  ms inc 772 if j <= 3073
  ms dec 297 if q > 1604
  kt inc 465 if hey > 1701
  w inc 987 if kt > 50
  xtz dec 180 if q == 1606
  um dec -823 if gus != 2284
  hey inc -964 if um == 487
  kt inc 387 if cl > -4046
  cl dec -167 if gi == 1209
  """

  describe "largest register" do
    test "returns 0 after skipping an instruction" do
      assert Registers.largest("a inc 1 if a > 1") == 0
    end

    test "inc" do
      assert Registers.largest("a inc 1 if a == 0") == 1
    end

    test "inc negative" do
      assert Registers.largest("a inc -1 if a == 0") == -1
    end

    test "dec" do
      assert Registers.largest("a dec 100 if a == 0") == -100
    end

    test "dec negative" do
      assert Registers.largest("a dec -23 if a == 0") == 23
    end

    test "==" do
      assert Registers.largest("a inc 10 if a == 1") == 0
      assert Registers.largest("a inc 10 if a == 0") == 10
    end

    test "<" do
      assert Registers.largest("a inc 10 if a < 0") == 0
      assert Registers.largest("a inc 10 if a < 1") == 10
    end

    test "<=" do
      assert Registers.largest("a inc 10 if a <= 0") == 10
      assert Registers.largest("a inc 10 if a <= -1") == 0
    end

    test ">" do
      assert Registers.largest("a inc 10 if a > 0") == 0
      assert Registers.largest("a inc 10 if a > -1") == 10
    end

    test ">=" do
      assert Registers.largest("a inc 10 if a >= 0") == 10
      assert Registers.largest("a inc 10 if a >= 1") == 0
    end

    test "!=" do
      assert Registers.largest("a inc 10 if a != 0") == 0
      assert Registers.largest("a inc 10 if a != 1") == 10
    end

    test "multiple lines" do
      assert Registers.largest("""
             a inc 10 if a >= 0
             a dec 10 if a == 10
             a inc 1 if a <= 1
             """) == 1
    end

    test "largest" do
      assert Registers.largest("""
             a inc 10 if a == 0
             b inc 100 if b == 0
             """) == 100
    end

    test "example" do
      assert Registers.largest("""
             b inc 5 if a > 1
             a inc 1 if b < 5
             c dec -10 if a >= 1
             c inc -20 if c == 10
             """) == 1
    end

    test "puzzle input" do
      assert Registers.largest(@input) == 3089
    end
  end

  describe "largest ever" do
    test "once" do
      assert Registers.largest_ever("a inc 1 if a == 0") == 1
    end

    test "incremental" do
      assert Registers.largest_ever("""
             a inc 1 if a == 0
             a inc 2 if a > 0
             """) == 3
    end

    test "decreases" do
      assert Registers.largest_ever("""
             a inc 1 if a == 0
             a dec 2 if a > 0
             """) == 1
    end

    test "puzzle input" do
      assert Registers.largest_ever(@input) == 5391
    end
  end
end
