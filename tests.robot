*** Settings ***
Documentation     Test accounting operations.
Library           accounting.py

*** Test Cases ***
The net income should equal revenues minus expenses
    [Template]    Revenues of ${revenues} and expenses of ${expenses} should equal ${expected} net income
    1256.25    930.33    325.92
    3.0    2.0    1.0
    100.20    462.12    -361.92
    200.0    200.0    0

*** Keywords ***
Revenues of ${revenues} and expenses of ${expenses} should equal ${expected} net income
    ${net_income}=    Net Income    ${revenues}    ${expenses}
    Should Be Equal As Numbers    ${net_income}    ${expected}
