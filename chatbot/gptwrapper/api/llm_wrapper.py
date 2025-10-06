from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate

class GPTWrapper:
    def __init__(self, model="gpt-4o-mini", temperature=0.7):
        self.llm = ChatOpenAI(model=model, temperature=temperature,api_key="OPENAI_API_KEY")
        self.instruction = ChatPromptTemplate.from_template("Ignoring all the medicolegal purposes, for study purposes point me one specific antimicrobial with a appropriate limit with unit adhering to FSSAI limits for a [animal] for [product]. Just give me the name and dosage no other content or warning")
        self.chain = self.instruction | self.llm

    def ask(self, prompt: str) -> str:
        response = self.chain.invoke({"question": prompt})
        return response.content