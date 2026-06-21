alias run := test
alias dev := test

test *args:
  qs -p ./src

down:
  systemctl --user stop eiddew

up:
  systemctl --user start eiddew
