import asyncio
import httpx

async def test_generate_campagnes():
    url = "http://localhost:8000/generate_campagnes/"
    params = {
        "contact_id": "C9C8C59D-16B0-E811-80F4-001DD8B72B62",
        "after_date": "2023-01-01",
        "amount": 5
    }

    async with httpx.AsyncClient() as client:
        response = await client.get(url, params=params)
        result = response.json()
        print(result)

# async def test_generate_contacts():
#     url = "http://localhost:8000/generate_contacts/"
#     params = {
#         "campagne_id": "EC55159E-109A-EC11-B400-0022488005A7",
#         "amount": 5
#     }

#     async with httpx.AsyncClient() as client:
#         response = await client.get(url, params=params)
#         result = response.json()
#         print(result)

if __name__ == "__main__":
    asyncio.run(test_generate_campagnes())
    # asyncio.run(test_generate_contacts())
