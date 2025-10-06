from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from .llm_wrapper import GPTWrapper

gpt = GPTWrapper()  

@csrf_exempt
def ask_gpt(request):
    if request.method == "POST":
        try:
            data = json.loads(request.body)
            prompt = data.get("prompt", "")
            if not prompt:
                return JsonResponse({"error": "Prompt is required"}, status=400)

            answer = gpt.ask(prompt)
            return JsonResponse({"response": answer})
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=500)

    return JsonResponse({"error": "Only POST allowed"}, status=405)
