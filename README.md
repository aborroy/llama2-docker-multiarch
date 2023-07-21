# llama2 Docker Image for AMD64 and ARCH64

## Introduction

This repository contains a Dockerfile to be used as a conversational prompt for [Llama 2](https://ai.meta.com/llama/). This Docker Image doesn't support CUDA cores processing, but it's available in both `linux/amd64` and `linux/arm64` architectures. Hence, this Docker Image is only recommended for local testing and experimentation.

This image has been built from following resources:

* Adrien Brault script to run Llama 2 in Mac OS: https://gist.github.com/adrienbrault/b76631c56c736def9bc1bc2167b5d129
* Llama 2 model from Hugging Face: https://huggingface.co/TheBloke/Llama-2-13B-chat-GGML

Prebuilt Docker Image is available in [Docker Hub](https://hub.docker.com/repository/docker/angelborroy/llama2/general).

## Running

The prompt can be passed using the environment variable `PROMPT`. The Docker Image can be run using the following command:

```bash
docker run -e PROMPT="Why Alfresco is a great Open Source platform for Document Management?" angelborroy/llama2:1.0.0

[PROMPT] Why Alfresco is a great Open Source platform for Document Management? [/PROMPT]  
Alfresco is a popular open-source platform for document management and content management. Here are some reasons why Alfresco is considered a great open-source platform for document management:
1. Powerful Content Modeling
2. Scalable Architecture
3. Open and Flexible
4. Rich Content Services
5. Integration with Other Systems
6. Mobile Access
7. Security and Governance
8. Open API
9. Large Community and Ecosystem
10. Cost-Effective
Overall, Alfresco is a powerful and flexible open-source platform for document management that provides a wide range of features and benefits for organizations looking to manage their content effectively. 
[end of text]
```

## Building locally

Building the Docker Image locally with tag name `llama2` can be done using regular Docker command.

```
docker build . -t llama2
```