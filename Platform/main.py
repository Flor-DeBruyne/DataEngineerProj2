from fastapi import FastAPI

app = FastAPI()

root_path = '/'
epic3_path = '/epic3/{contact_id}'
epic4_path = '/epic4/{contact_id}'
epic5_path = '/epic5/{campagne_id}'

@app.get('/')
async def root():
    return {
        'Status' : 'Operational'
    }

@app.get(epic3_path)
async def handle_epic3(contact_id: str):
    return {
        'result' : 'TO_DO',
        'param': contact_id
    }

@app.get(epic4_path)
async def handle_epic4(contact_id: str):
    return {
        'result' : 'TO_DO',
        'param': contact_id
    }

@app.get(epic5_path)
async def handle_epic5(campagne_id: str):
    return {
        'result' : 'TO_DO',
        'param': campagne_id
    }