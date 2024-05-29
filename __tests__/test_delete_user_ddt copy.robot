*** Settings ***
Library    RequestsLibrary
Library    DataDriver    ../fixtures/csv/user.csv    dialect=excel
Test Template    Delete User DDT

*** Variables ***
${url}    https://petstore.swagger.io/v2/user

*** Test Cases ***
TC001    ${id}    ${username}    ${firstName}    ${lastName}    ${email}    ${password}    ${phone}    ${userStatus}
# TC002    2849824874    dido    ${firstName}    ${lastName}    ${email}    ${password}    ${phone}    ${userStatus}

*** Keywords ***
Delete User DDT
    [Arguments]    ${id}    ${username}    ${firstName}    ${lastName}    ${email}    ${password}    ${phone}    ${userStatus}
    # ${id}    Convert To Integer    ${id}
    ${userStatus}    Convert To Integer    ${userStatus}

    ${body}    Create Dictionary    id=${id}    username=${username}    firstName=${firstName}    
    ...    lastName=${lastName}    email=${email}    password=${password}    
    ...    phone=${phone}    userStatus=${userStatus}

    ${response}    DELETE    ${{$url + "/" + $username}}    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console      ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[code]       ${{int(200)}}
    Should Be Equal    ${response_body}[type]       unknown
    Should Be Equal    ${response_body}[message]    ${username}