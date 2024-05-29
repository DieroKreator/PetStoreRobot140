*** Settings ***
# Bibliotecas e Configurações
Library    RequestsLibrary   

*** Variables ***
# Objetos, Atributos e Variables
${url}    https://petstore.swagger.io/v2/user
# ${FILE_PATH}    ../../fixtures/csv/user.csv

${user_id}       60814379198
${username}      figotti
${firstName}     Fidel
${lastName}      Santos
${email}         figotti@gmail.com
${password}      123456
${phone}         51452895685
${userStatus}    1

*** Test Cases ***

Post user
    ${body}    Create Dictionary    id=${user_id}    username=${username}    firstName=${firstName}    lastName=${lastName}    
    ...                             email=${email}  password=${password}    phone=${phone}    userStatus=${userStatus}

    ${response}    POST    url=${url}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console      ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]       ${{int(200)}}
    Should Be Equal    ${response_body}[type]       unknown
    Should Be Equal    ${response_body}[message]    ${user_id}

Get user
    ${response}    GET    ${{$url + '/' + $username}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]           ${{int($user_id)}} 
    Should Be Equal    ${response_body}[firstName]    ${firstName}
    Should Be Equal    ${response_body}[phone]        ${phone}

Put user
    ${body}    Evaluate    json.loads(open('./fixtures/json/user2.json').read())

    ${response}    PUT    url=${{$url + '/' + $username}}   json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}
    
    Status Should Be    200
    Should Be Equal    ${response_body}[code]       ${{int(200)}}
    Should Be Equal    ${response_body}[type]       unknown
    Should Be Equal    ${response_body}[message]    ${user_id}

Delete user
    ${response}    DELETE    ${{$url + '/' + $username}}    
    
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]       ${{int(200)}}
    Should Be Equal    ${response_body}[type]       unknown
    Should Be Equal    ${response_body}[message]    ${username}

# Post user dynamic
#     [Documentation]    Upload CSV file with parameters and validate response
#     ${file}    Get File For Streaming Upload    ${FILE_PATH}
#     ${files}=   Create Dictionary   file=${file}   operator_format=false   Content-Type=multipart/form-data
#     ${body}    Evaluate    json.loads(open('./fixtures/json/user2.json').read())

#     ${response}    POST    url=${url}    json=${body}

#     ${response_body}    Set Variable    ${response.json()}
#     Log To Console      ${response_body}

#     Status Should Be    200
#     Should Be Equal    ${response_body}[code]       ${{int(200)}}
#     Should Be Equal    ${response_body}[type]       unknown
#     Should Be Equal    ${response_body}[message]    ${user_id}
