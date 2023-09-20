# Converting Salsa20 ECRYPT test vectors to JSON

The [Salsa20 spec](https://cr.yp.to/snuffle/spec.pdf) provides test vectors for different parts of the protocol but do not provide any vectors for the encryption function.

The [eSTREAM project](https://www.ecrypt.eu.org/stream/) was a multi-year project to promote efficient and compact stream ciphers designs. As part of this effort the [Salsa20/12](https://www.ecrypt.eu.org/stream/e2-salsa20.html) cipher was analized and by this, a good amount of test vectors for the encryption function were created.

This is an old project and we were not able to find the test vectors in the official site. The following 2 files are what i think were the official test vectors:

- [salsa20-128.64-verified.test-vectors](https://github.com/das-labor/legacy/blob/master/microcontroller-2/arm-crypto-lib/testvectors/salsa20-128.64-verified.test-vectors)
- [salsa20-256.64-verified.test-vectors](https://github.com/das-labor/legacy/blob/master/microcontroller-2/arm-crypto-lib/testvectors/salsa20-256.64-verified.test-vectors)

The goal of this small project is to convert those test vectors that ([seems to be](https://crypto.stackexchange.com/questions/81087/ecrypt-salsa20-test-vectors-interpretation)) [NESSIE format](https://www.ecrypt.eu.org/stream/perf/#overview) to JSON so more modern Salsa20 implementations can use them easily.

## Preparation

We downloaded the two files with test vectors listed in the previous section into the project ([salsa20-128.64-verified.test-vectors](salsa20-128.64-verified.test-vectors) and [salsa20-256.64-verified.test-vectors](salsa20-256.64-verified.test-vectors)) as a starting point.

Then we found a [salsa20 C implementation](https://github.com/alexwebr/salsa20) that is actually using this test vectors and served as an inspiration for this project.

First, the implementation trims the header and the tail of the original files and so we do. Our test vector files now are:

- [test_vectors.128](https://github.com/alexwebr/salsa20/blob/master/test_vectors.128)
- [test_vectors.256](https://github.com/alexwebr/salsa20/blob/master/test_vectors.256)

We downloadeed this files and are now part of the project too: [test_vectors.128](test_vectors.128) and [test_vectors.256](test_vectors.256)

It is easy to compare and see no test data was modified but just file header and tail information was removed from one version to the other:

```
% diff salsa20-256.64-verified.test-vectors test_vectors.256
1,12d0
< 
< Primitive Name: Salsa20
< =======================
< Profile: S3___
< Key size: 256 bits
< IV size: 64 bits
< 
< Test vectors -- set 1
< =====================
< 
< (stream is generated by encrypting 512 zero bytes)
< 
2603,2605d2590
< 
< 
< End of test vectors
% diff salsa20-128.64-verified.test-vectors test_vectors.128
1,15d0
< ********************************************************************************
< *                          ECRYPT Stream Cipher Project                        *
< ********************************************************************************
< 
< Primitive Name: Salsa20
< =======================
< Profile: S3___
< Key size: 128 bits
< IV size: 64 bits
< 
< Test vectors -- set 1
< =====================
< 
< (stream is generated by encrypting 512 zero bytes)
< 
2167,2170d2151
< 
< 
< End of test vectors
< 
% 
```
The C implementaion use shell scripts for generating unit tests from the test vector files. One for each type: [vectors_to_tests_128.sh](https://github.com/alexwebr/salsa20/blob/master/vectors_to_tests_128.sh) and [vectors_to_tests_256.sh](https://github.com/alexwebr/salsa20/blob/master/vectors_to_tests_256.sh)

We do a similar approach here but converting from the test files to JSON in [vectors_to_json.sh](vectors_to_json.sh).

## Usage

```
% ./vectors_to_json.sh 128 test_vectors.128 test_vectors_128.json
% ./vectors_to_json.sh 256 test_vectors.256 test_vectors_256.json
```

## New JSON tests vectors

Feel free to use them in any way.

- [test_vectors_128.json](test_vectors_128.json)
- [test_vectors_256.json](test_vectors_256.json)

## References

- Salsa20 spec: https://cr.yp.to/snuffle/spec.pdf
- ECRYPT: https://www.ecrypt.eu.org/
- eSTREAM project: https://www.ecrypt.eu.org/stream/
- eSTREAM Salsa20/12: https://www.ecrypt.eu.org/stream/e2-salsa20.html
- ECRYPT Salsa20 Test Vectors Interpretation: https://crypto.stackexchange.com/questions/81087/ecrypt-salsa20-test-vectors-interpretation
- NESSIE format: https://www.ecrypt.eu.org/stream/perf/#overview
- Salsa20 C implementation: https://github.com/alexwebr/salsa20/
