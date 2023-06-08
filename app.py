from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
from io import BytesIO
import urllib
import json

from tensorflow.keras.preprocessing.image import load_img, img_to_array
from tensorflow.keras.models import load_model
from tensorflow.keras.applications.vgg16 import preprocess_input

app = Flask(__name__)
CORS(app)
# 모델 불러오기
model = load_model("C:/Users/user/Downloads/89216(ver8,flip).h5")

#쇼핑 API 연동
client_id = "YmwEYBDY7aXnrocNn5Zx"
client_secret = "0daNsnl46p"

# 예측에 사용할 함수 정의
def find_class(file):
    # 테스트할 이미지 로드 및 전처리
    img = load_img(file, target_size=(224, 224))
    img = img_to_array(img)
    img = np.expand_dims(img, axis=0)
    img = preprocess_input(img)

    # 예측 수행
    predictions = model.predict(img)
    predicted_classes = np.argsort(-predictions[0])[:2]  # 상위 2개 클래스 선택

    # 클래스 맵
    class_map = {
        0: '모던',
        1: '캐주얼',
        2: '내추럴',
        3: '북유럽',
        4: '빈티지',
        5: '클래식'
    }

    class_Explanation={
        0:'형태적으로는 번잡한 장식 없이 직선적인 디자인으로 깨끗하고 간결한 기능미를 느낄 수 있다. 색채요소로서는 무채색 혹은 단일한 강조색이 사용되며, 강렬한 명암대비 등의 특징을 가진다. 재료로는 금속, 유리 등 딱딱하고 차가운 소재가 활용된다. 기능적이고, 합리적인 깔끔한 이미지를 준다.',
        1:'큰 무늬의 체크, 스트라이프, 동물 모티브의 무늬 등 독특한 무늬가 활 용된다. 색채요소로는 2-3가지의 다양한 색상 기준으로 다채로운 색상 이 활용된다. 재료로는 플라스틱, 패브릭 등의 가벼운 소재가 활용된다. 단순하고 젊고 경쾌한 분위기를 연출한다.',
        2:'자연을 떠올리게 하는 식물무늬 혹은 체크무늬 등이 활용된다. 색채요 소로는 자연에서 보기 쉬운 녹색계열, 아이보리계열 이 활용된다. 재료로는 목재, 흙, 돌 등이 활용된다. 목재 결 등 부재의 자연적 형태와 특 성이 잘 드러나도록 하며, 패브릭 등이 많이 활용된다.',
        3:'자연적인 질감과 인공적인 마감이 혼합된 느낌으로 나무,철,스테인레스,타일 소재를 주로 사용하며, 색상적인 느낌으론 밝고 깨끗한 색상을 사용하며, 흰색 벽면이 많이 사용되어 공간을 넓어 보이게 하는 특징이 있다. 목재 소재와 자연스러운 텍스처, 둥근 형태 등이 사용되어 포근하고 아늑한 분위기를 연출한다.',
        4:'짙은 갈색과 어두운 색 위주의 원목가구를 주로 사용하는 빈티지 스타일은 과거의 경험과 추억을 떠올리게 하는 요소들을 사용한다. 오래된 가구나 소품, 레트로한 패턴이나 색상 등이 활용되며, 따뜻하고 낡은 느낌을 연출한다.',
        5:'큰 무늬의 체크, 스트라이프, 동물 모티브의 무늬 등 독특한 무늬가 활 용된다. 색채요소로는 2-3가지의 다양한 색상 기준으로 다채로운 색상 이 활용된다. 재료로는 플라스틱, 패브릭 등의 가벼운 소재가 활용된다. 단순하고 젊고 경쾌한 분위기를 연출한다.'
    }

    # 예측 결과 반환
    result = []
    for i, class_index in enumerate(predicted_classes):
        class_name = class_map[class_index]
        class_probability = float(predictions[0][class_index])
        result.append({"class": class_name, "probability": class_probability, "explanation": class_Explanation[class_index]})
    style=result[0]['class']
    shopping_result = style_analysis(style)
    result.append(shopping_result)
    print(result)
    return result

def style_analysis(style):
    #style = request.json['style']+"스타일 가구"
    #print(style)
    encText = urllib.parse.quote(style+"스타일 가구")
    url = "https://openapi.naver.com/v1/search/shop?query=" + encText+"&sort=date"
    api_request = urllib.request.Request(url)
    api_request.add_header("X-Naver-Client-Id",client_id)
    api_request.add_header("X-Naver-Client-Secret",client_secret)
    response = urllib.request.urlopen(api_request)
    rescode = response.getcode()

    if(rescode==200):
        response_body = response.read()
        response_dict = json.loads(response_body.decode('utf-8'))
        image_urls = [item['link'] for item in response_dict['items'][:10]] if response_dict['items'] else []
        image_src = [item['image'] for item in response_dict['items'][:10]] if response_dict['items'] else []
        return {'image_urls': image_urls,'image_src':image_src}
    else:
        return {'error': 'API request error'}

# 이미지 업로드 및 결과 반환하는 엔드포인트 정의
@app.route("/upload", methods=["POST"])
def upload_image():
    if "file" not in request.files:
        return "No file uploaded.", 400

    file = request.files["file"]
    if file.filename == "":
        return "No file selected.", 400

    # BytesIO 객체로 변환
    image_bytes = BytesIO()
    file.save(image_bytes)
    image_bytes.seek(0)

    # 결과 반환
    result = find_class(image_bytes)
    return jsonify(result)




# @app.route('/api/style_analysis', methods=['POST'])
# def style_analysis(style):
#     if request.method == 'POST':
#         style = request.json['style']+"스타일 가구"
#         #print(style)
#         encText = urllib.parse.quote(style)
#         url = "https://openapi.naver.com/v1/search/shop?query=" + encText+"&sort=date"
#         api_request = urllib.request.Request(url)
#         api_request.add_header("X-Naver-Client-Id",client_id)
#         api_request.add_header("X-Naver-Client-Secret",client_secret)
#         response = urllib.request.urlopen(api_request)
#         rescode = response.getcode()

#         if(rescode==200):
#             response_body = response.read()
#             #print(response_body)
#             response_dict = json.loads(response_body.decode('utf-8'))
#             #print(response_dict)
#             image_urls = [item['link'] for item in response_dict['items'][:10]] if response_dict['items'] else []
#             image_src = [item['image'] for item in response_dict['items'][:10]] if response_dict['items'] else []
#             return jsonify({'image_urls': image_urls,'image_src':image_src}), 200
#         else:
#             return jsonify({'error': 'API request error'}), 500


if __name__ == "__main__":
    app.run(debug=True)
