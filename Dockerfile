ARG MODEL=llama-2-13b-chat.ggmlv3.q4_0.bin

FROM ubuntu:22.04 AS builder
ARG MODEL

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y build-essential git wget python3 pip && pip install numpy

# Thanks to Adrien Brault (https://gist.github.com/adrienbrault/b76631c56c736def9bc1bc2167b5d129)
# Clone llama.ccp and pin to working commit
RUN git clone https://github.com/ggerganov/llama.cpp.git && cd llama.cpp && git checkout e519621 && make

WORKDIR /llama.cpp

ENV MODEL=$MODEL
RUN wget "https://huggingface.co/TheBloke/Llama-2-13B-chat-GGML/resolve/main/${MODEL}"

# Per discussion here (https://huggingface.co/TheBloke/Llama-2-13B-chat-GGML/discussions/14#64fe1eef8710fc5ebddf43e4)
# Dane Fetterman added the following line:
RUN ./convert-llama-ggml-to-gguf.py --eps 1e-5 -i ${MODEL} -o ${MODEL}.gguf
# Trying to keep container size down
RUN rm ${MODEL}
RUN pip uninstall -y numpy
RUN apt-get remove -y python3 pip

FROM ubuntu:22.04 AS final
ARG MODEL

ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser
USER appuser

COPY --from=builder /llama.cpp /llama.cpp

WORKDIR /llama.cpp


ENV MODEL=$MODEL
ENV PROMPT="Where is philadelphia?"


ENTRYPOINT ./main -t 8 -ngl 1 -m ${MODEL}.gguf --color -c 2048 --temp 0.7 --repeat_penalty 1.1 -n -1 -p "[PROMPT] ${PROMPT} [/PROMPT]"

# docker build -f Dockerfile-llama2 -t llama2 .
# docker run -u 0 -it llama2 bash
# docker run -e PROMPT="Where is philadelphia?" llama2
