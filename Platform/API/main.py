from fastapi import FastAPI
from routers import epic4, result_lists
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

## Defining requests handlers
@app.get('/')
async def root():
    return {
        'Status' : 'Operational'
    }

app.include_router(result_lists.router)
app.include_router(epic4.router)
