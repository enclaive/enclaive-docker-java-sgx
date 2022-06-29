# Gradle build stage
FROM gradle:7.4-jdk17 AS builder

COPY ./src/project /home/gradle

RUN gradle build jar && cp /home/gradle/build/libs/*.jar /enclave.jar

# Enclave image build stage
FROM enclaive/gramine-os:latest

RUN apt-get update \
    && apt-get install -y libprotobuf-c1 openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /enclave.jar /app/
COPY ./java.manifest.template /app/
COPY ./entrypoint.sh /app/

WORKDIR /app

RUN gramine-argv-serializer "/usr/lib/jvm/java-17-openjdk-amd64/bin/java" "-jar" "/app/enclave.jar" > jvm_args.txt

RUN gramine-sgx-gen-private-key \
    && gramine-manifest -Dlog_level=error -Darch_libdir=/lib/x86_64-linux-gnu java.manifest.template java.manifest \
    && gramine-sgx-sign --manifest java.manifest --output java.manifest.sgx

ENTRYPOINT ["sh", "entrypoint.sh"]
