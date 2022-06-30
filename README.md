<div align="center">

# Gramine Java Proof of Concept

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![License][license-shield]][license-url]
[![Last Commit][last-commit-shield]][last-commit-url]

This repo contains a small demo of running a JVM inside an SGX enclave using Gramine

[About The Project](#about-the-project) •
[Getting started](#getting-started) •
[Gramine JVM Image structure](#gramine-jvm-image-structure) •
[Modifying the PoC](#modifying-the-poc-to-run-a-different-jvm-based-application)

</div>

## About The Project

![Enclave log][log-img]

Confidential computing is a fast-growing space. Developers will face growing pressure to move applications to a zero-trust infrastructure. Using Gramine, developers can deploy their existing source code inside an enclave instead of doing a full rewrite.

This PoC has its origin in the system security lecture by [@sebastiangajek](https://github.com/sebastiangajek) at Flensburg University of Applied Sciences.

Experienced issues in this PoC:
* Broken `EPOLL` support -> Webservers such as Netty fail to start
* Poor performance (running `gramine-sgx java` to seeing `"Hello world!"` took around 15 seconds)



## Getting started

### Platform requirements
Check for *Intel Security Guard Extension (SGX)* presence by running the following
```sh
grep sgx /proc/cpuinfo
```
Alternatively have a thorough look at Intel's [processor list](https://www.intel.com/content/www/us/en/support/articles/000028173/processors.html).

### Running this PoC
Assuming all necessary SGX drivers are installed on the host, run the following
```sh
git clone git@github.com:mortenboettger/gramine-java-poc.git
cd gramine-java-poc
docker-compose up
```



## Gramine JVM Image structure

### Build
The Docker image build consists of two stages. The first ("builder") stage uses Gradle to build the Gradle-based [Java project](src/project) and creates a runnable JAR.

The second ("gramine") stage gathers all the necessary resources and generates and signs the manifest based on the [existing template](java.manifest.template).

### Run
On container startup, the [entrypoint script](entrypoint.sh) acquires the necessary token and launches the enclave.



## Modifying the PoC to run a different JVM-based application

### Gradle-based JVM application
Replace the `project` folder, at `src/project`, with your Gradle-based project and change the referenced folders and Gradle tasks inside the builder stage in the Dockerfile accordingly.

### Non-Gradle-based JVM application
Replace the `project` folder, at `src/project`, with your JVM application project and exchange the builder stage inside the Dockerfile with your needed build config. Make sure to copy the resulting jar to the root folder of your builder stage and for convenience name it `enclave.jar`. This way you most likely won´t have to touch the second stage.


## License

Distributed under the GPLv3 License. See `LICENSE` for more information.



## Acknowledgments

This project greatly celebrates all contributions from the gramine team and the amazing progress made by the [enclaive](https://github.com/enclaive) team.

* [enclaive.io](https://github.com/enclaive)
* [gramine-os Docker Image](https://hub.docker.com/r/enclaive/gramine-os)
* [Gramine Project](https://github.com/gramineproject)
* [Intel SGX](https://github.com/intel/linux-sgx-driver)
* [Best-README-Template](https://github.com/othneildrew/Best-README-Template)



[contributors-shield]: https://img.shields.io/github/contributors/mortenboettger/gramine-java-poc?style=for-the-badge
[contributors-url]: https://github.com/mortenboettger/gramine-java-poc/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/mortenboettger/gramine-java-poc.svg?style=for-the-badge
[forks-url]: https://github.com/mortenboettger/gramine-java-poc/network/members
[stars-shield]: https://img.shields.io/github/stars/mortenboettger/gramine-java-poc.svg?style=for-the-badge
[stars-url]: https://github.com/mortenboettger/gramine-java-poc/stargazers
[license-shield]: https://img.shields.io/github/license/mortenboettger/gramine-java-poc.svg?style=for-the-badge
[license-url]: https://github.com/mortenboettger/gramine-java-poc/blob/main/LICENSE
[last-commit-shield]:https://img.shields.io/github/last-commit/mortenboettger/gramine-java-poc/main.svg?style=for-the-badge
[last-commit-url]: https://github.com/mortenboettger/gramine-java-poc/commits/main
[log-img]: images/enclave_log.png
