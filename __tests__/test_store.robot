*** Settings ***
Library    RequestsLibrary   

*** Variables ***
${url}    https://petstore.swagger.io/v2/store/order

${order_id}    9223372036854775000
${petId}    602740501
${quantity}    1
${shipDate}    2024-05-26T20:11:15.408+0000
${status}    placed
${complete}    true

*** Test Cases ***

Post store
    ${body}    Create Dictionary    id=${order_id}    petId=${petId}    quantity=${quantity}    
    ...                             shipDate=${shipDate}  status=${status}    complete=${complete}
    
    ${response}    POST    url=${url}    json=${body}
    # url=${{$url + '/' + 'order'}} 

    ${response_body}    Set Variable    ${response.json()}
    Log To Console      ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]       ${{int(${order_id})}}
    Should Be Equal    ${response_body}[petId]       ${{int(${petId})}}
    Should Be Equal    ${response_body}[quantity]    ${{int(${quantity})}}

Get store
    ${response}    GET    ${{$url + '/' + $order_id}}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[id]       ${{int(${order_id})}}
    Should Be Equal    ${response_body}[shipDate]    ${shipDate}
    Should Be Equal    ${response_body}[status]        ${status}

Delete store
    ${response}    DELETE    ${{$url + '/' + $order_id}}    
    
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]       ${{int(200)}}
    Should Be Equal    ${response_body}[type]       unknown
    Should Be Equal    ${response_body}[message]    ${order_id}