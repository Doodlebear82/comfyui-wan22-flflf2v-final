# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

# build-time tokens for gated downloads — never baked into final image.
# pass via: docker build --build-arg HF_TOKEN=$HF_TOKEN ...
ARG HF_TOKEN=""

# download models into comfyui
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/ai-forever/Real-ESRGAN/resolve/main/RealESRGAN_x2.pth' --relative-path models/upscale_models --filename 'RealESRGAN_x2plus.pth' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done

# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/

# user-provided inputs override the auto-generated placeholders above.
RUN wget --progress=dot:giga -O '/comfyui/input/ComfyUI-close_up_00002_.jpg' "https://cool-anteater-319.convex.cloud/api/storage/0b09c543-e11d-48a9-83db-319bf4dbc7a7"
RUN wget --progress=dot:giga -O '/comfyui/input/ComfyUI-close_up_00003_.png' "https://cool-anteater-319.convex.cloud/api/storage/3400cb1f-39b4-4619-ad39-a89c6fc2845c"
RUN wget --progress=dot:giga -O '/comfyui/input/ComfyUI_00063-edit_.jpg' "https://cool-anteater-319.convex.cloud/api/storage/d258dc25-716e-4a5a-a251-c9dfbe261e7f"
