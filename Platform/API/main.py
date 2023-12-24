from fastapi import FastAPI
from routers import epic4, result_lists

app = FastAPI()

## Defining requests handlers
@app.get('/')
async def root():
    return {
        'Status' : 'Operational'
    }

app.include_router(result_lists.router)
app.include_router(epic4.router)
