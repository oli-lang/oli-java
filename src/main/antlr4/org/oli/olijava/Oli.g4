grammar Oli;

tokens {
  TEST
}

something : TEST*;

TEST : '0' .. '9'; 