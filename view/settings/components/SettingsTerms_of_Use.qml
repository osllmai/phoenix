import QtQuick 2.15
import QtQuick.Controls 2.15
import '../../component_library/style' as Style

Item {
    id: controlId
    ScrollView {
        id: scrollInput
        width: parent.width
        height: parent.height
        ScrollBar.vertical.interactive: true

        ScrollBar.vertical.policy: scrollInput.contentHeight > scrollInput.height
                                   ? ScrollBar.AlwaysOn
                                   : ScrollBar.AlwaysOff

        ScrollBar.vertical.active: (scrollInput.contentY > 0) &&
                        (scrollInput.contentY < scrollInput.contentHeight - scrollInput.height)

        TextArea{
            id: textId
            text:"# Terms of Use:

**Established & Effective Date:** January 01, 2024\
**Update:** April 26, 2025

Please read these terms of use (agreement) carefully before using the services offered by Durabuy American Import Export LLC (Company). By visiting the website <https://osllm.ai> and/or using the services in any manner, you agree that you have read, understood, and accept to be bound by these terms and conditions. If the terms of this agreement are considered an offer, acceptance is expressly limited to such terms. If you do not unconditionally agree to all the terms and conditions of this agreement, you have no right to use the website <https://osllm.ai>, applications, extensions, or services provided by OS LLM. Use of the Company's services is expressly conditioned upon your acceptance of these terms.

- **Country** **refers to:** United States
- **Country:** United States
- **Company:** Durabuy American Import Export LLC (referred to as the Company, We, Us, or Our)
- **Address:** 7343 N Teutonia Ave Unit 7, Milwaukee, WI 53209, United States
- **Phone:** +1 (971) 400-2132
- **Website:** [osllm.ai](https://osllm.ai)
- **Email:** [support@osllm.ai](mailto:support@osllm.ai)

## Children's Privacy:

The Company does not knowingly collect or solicit personal information from anyone under the age of 13, nor does it knowingly allow such individuals to register for the Services. If you are under 13 years of age, please do not attempt to register for the Services or provide any personal information to us, including your name, address, telephone number, or email address. No person under the age of 13 may provide any personal information to the Company or through the Services.\ In the event that the Company becomes aware that it has collected personal information from a child under age 13 without verifying parental consent, the Company will delete that information promptly. If you believe that the Company might have any information from or about a child under 13, please contact us at [support@osllm.ai](mailto:support@osllm.ai).

## User Representations and Warranties:

By accessing or using the Services, you represent and warrant to the
Company that:

1.  **Legal Capacity**:

You are of legal age to form a binding contract  with the Company and are not prohibited by law from accessing or using the Services.

2.  **Accurate Information**:
All registration information you submit is  accurate, current, and truthful.

3.  **Maintenance of Information**:

You will maintain the accuracy of such information and promptly update it as necessary.

Additionally, you certify that you are legally permitted to use and access the Services and take full responsibility for your selection, use, and access to the Services. This Agreement is void where prohibited by law, and the right to access the Services is revoked in such jurisdictions.

**Placing Orders for Goods:**

By placing an order for goods through our Service, you confirm that you are legally capable of entering into binding contracts.

**Your Information:**

When you place an order for goods available on our Service, we may
request certain information necessary to process your order. This
information may include, but is not limited to:

- Your name
- Your email address
- Your phone number
- Your credit card number
- The expiration date of your credit card
- Your billing address
- Your shipping information

You represent and warrant that:

1.  You have the legal right to use any credit or debit card(s) or other payment method(s) associated with your order.

2.  All information you provide to us is true, correct, and complete.

By submitting your information, you authorize us to share it with third-party payment processors solely for the purpose of completing your order.

**Order Cancellation:**

We reserve the right to refuse or cancel your order at any time for
specific reasons, including but not limited to:

1.  **Goods Availability:**

If the goods you ordered are unavailable.

2.  **Pricing Errors:**

If there are errors in the description or  pricing of the goods.

3.  **Order Errors:**

If there are errors in your order details.

**Protection Against Abnormal User Behavior**

To ensure fairness and maintain the normal operation of our services, we
monitor and take measures against abnormal user behavior. If a user's
conduct violates our Terms of Use or Code of Conduct, such as:

1.  **Manipulating Membership Status:**

Attempting to manipulate membership status through improper means.

3.  **Disruptive Cancellations:** Intentionally making repetitive
    cancellations to disrupt service operations.

4.  **Exploiting System Vulnerabilities:** Attempting to exploit system
    vulnerabilities to obtain undue benefits.

5.  **Account Sharing or Reselling:** Violating the single-account user
    principle by reselling or sharing the account with multiple users.

We reserve the right to immediately terminate or suspend the user's membership and/or right to use the services. In such cases, a refund may not be offered. Each situation will be assessed on a case-by-case basis to ensure a fair and safe environment for all users.

# Availability, Errors, and Inaccuracies:

We are constantly updating our offerings of Goods on the Service.
However, the Goods available on our Service may be mispriced, described inaccurately, or unavailable. We may also experience delays in updating information regarding our Goods on the Service and in our advertising on other websites.

We cannot and do not guarantee the accuracy or completeness of any information, including prices, product images, specifications, availability, and services. We reserve the right to change or update information and to correct errors, inaccuracies, or omissions at any time without prior notice.

## Prices Policy:

The Company reserves the right to revise its prices at any time prior to accepting an Order.

Prices quoted may be revised by the Company after accepting an Order in the event of occurrences affecting delivery, such as government actions, variations in customs duties, increased shipping charges, higher foreign exchange costs, or any other matter beyond the Company's control. In such cases, you have the right to cancel your Order.

## Payments:

Payments can be made through valid credit or debit cards and are subject to validation checks and authorization by your card issuer. If we do not receive the required authorization, we will not be liable for any delay or non-delivery of your Order.

# Subscriptions:

## Subscription Period:

The Service, or certain parts of it, are available only with a paid Subscription. You will be billed in advance on a recurring and periodic basis, either monthly or yearly, depending on the Subscription plan you select when purchasing the Subscription. At the end of each period, your Subscription will automatically renew under the same conditions unless you cancel it or the Company cancels it.

## Subscription Cancellations:

You may cancel your Subscription renewal by contacting us at support@osllm.ai or through the dashboard. You will not receive a refund for fees already paid for the current Subscription period, and you will be able to access the Service until the end of your current Subscription period.

# Billing:

You must provide the Company with accurate and complete billing information, including your full name, address, state, zip code, telephone number, and valid payment method information.

If automatic billing fails for any reason, the Company will issue an electronic invoice indicating that you must proceed manually, by the specified deadline, with the full payment corresponding to the billing period as indicated on the invoice.

## Fee Changes:

The Company may modify Subscription fees at any time in its sole discretion. Any Subscription fee changes will become effective at the end of the current Subscription period.

The Company will provide you with reasonable prior notice of any changes to Subscription fees, giving you the opportunity to terminate your Subscription before the changes take effect.

Your continued use of the Service after the Subscription fee change comes into effect constitutes your agreement to pay the modified Subscription fee amount.

# Refunds:

We have established different refund policies based on subscription type, add-on package type, regional laws, and account status.

## Refund Process:

After you submit a refund request, we will manually review your order and send the review results or request additional information via the email you provided within 48 hours to five business days. Please ensure you check your email, including your spam folder, to avoid missing any important communications. Follow the instructions in the email carefully. If you fail to complete the next steps within the specified timeframe, we will be unable to process your refund.

## EU or Turkey Customers:

If you reside in the EU or Turkey, you are eligible to cancel your subscription and receive a refund within 4 days of purchase. This applies to both monthly and annual subscriptions. Please specify in your refund request that you are applying for a refund under EU or Turkey regulations. If there are any irregularities with your account, OS LLM ai customer service may require you to provide relevant proof when processing your refund request.

## All Other Customers:

While we strive to make our refund policy as fair as possible, OS LLM ai may not be able to fulfill your refund request if there are
irregularities with your account.

- Monthly Subscriptions: You can apply for a refund within 24 hours after the purchase charge. Please state the reason for your refund request in your application.

- Annual Subscriptions: Subscribers can apply for a full refund within 72 hours after the initial purchase charge date and time. No refunds will be granted for requests made after this period.

## Advanced Credits Add-on Package:

The Advanced Credits Add-on Package is a specific type of value-added benefit and is non-refundable once purchased. According to our Terms of Service:

- Unused Advanced Credits: Remain valid from the date of purchase and  can be used while the membership subscription is active. The amount paid  is non-refundable.

- Abnormal Situations: If you encounter abnormal situations such as restricted account access while using Advanced Credits, we will initiate an account risk assessment procedure. The assessment results will determine the subsequent course of action:

1. Normal Use: If your account is deemed to be in normal use, we will promptly restore access and ensure the continued validity of your Advanced Credits. No refunds will be offered in such cases.

2. Risk Control Violations: If the assessment confirms that the account has been banned due to triggering risk control mechanisms, we will be unable to restore your access privileges, and no refund will be provided.

## Additional Conditions:

- First Purchase Refunds Only: Refunds will only be processed for the first purchase. Subsequent purchases are not eligible for refunds.

- Usage Threshold: If you have used 10% or more of your purchased credits, we reserve the right not to issue a refund.

- Previous Refunds: If you have previously received a refund for our services, we reserve the right to deny subsequent refund requests. This policy is designed to prevent abuse of our refund system and ensure the fair use of our services.

If you need to inquire about refund-related issues, please follow the refund process outlined above to communicate with us via email. We recommend users carefully consider their usage needs before purchasing an Advanced Credits Add-on Package to ensure full utilization of the purchased credits.

# Promotions:

Promotions available through the Service may be subject to separate rules from these Terms. If you choose to participate in any Promotions, please review the applicable rules and our Privacy Policy. In the event of a conflict between the Promotion rules and these Terms, the Promotion rules will take precedence.

# User Accounts:

When you create an account with us, you must provide accurate, complete, and current information at all times. Failure to do so constitutes a breach of the Terms, which may result in the immediate termination of your account on our service.

You are responsible for safeguarding the password you use to access the service and for any activities or actions under your password, whether your password is with our service or a third-party social media service.

You agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any security breach or unauthorized use of your account.

You may not use as a username the name of another person or entity, a name that is not lawfully available for use, a name or trademark that is subject to any rights of another person or entity without appropriate authorization, or a name that is offensive, vulgar, or obscene.

We permit only one account per user. Additionally, you may only log into your account on up to ten devices. If you attempt to create multiple accounts, exceed the device limit, or violate our fair usage policy, we reserve the right to remove your data and restrict your access to our service.

# **Strengthening OS LLM ai Usage Regulations and Combating Illegal Third-party Activities:**

In order to maintain the fairness, security, and sustainable development of OS LLM ai, ensure that all users can enjoy high-quality services, and comprehensively protect user account security and privacy data, we have established this policy.

We explicitly prohibit the following behaviors: subscribing through
unofficial channels such as third-party payment platforms, account
sharing or reselling, circumventing our security measures through
technical means, and any behavior that violates our Terms of Service.

For users who violate the above regulations or related parties who
illegally profit, we will take severe measures, including immediately
suspending or terminating the relevant accounts, canceling all illegally
obtained benefits, and reserving the right to pursue legal liability.

To more effectively identify and prevent abnormal behavior, we have
further upgraded OS LLM ai's account security risk control system
while ensuring that the rights of normal users are not affected. We
understand that misjudgments may occur during the implementation
process, so we provide a dedicated appeal channel. If you believe your
account has been incorrectly processed, please contact us via email:
**[support@osllm.ai](mailto:support@osllm.ai)**. The OS LLM ai Security Team will
carefully and impartially review each appeal case.

We strongly recommend that all users purchase and use our services
through official channels. This not only ensures that your rights are
fully protected but is also the best way to support our continued
provision of high-quality services. We appreciate every user who abides
by the rules; your support enables our platform to thrive healthily.

# **Content Policy:**

## Your Right to Create and Post Content.

Our Service enables You to generate and post Content. You are solely responsible for the Content You create using the AI Service, including its legality, reliability, and appropriateness.

By generating and posting Content to the Service, you grant us a global, non-exclusive, royalty-free right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content within and through the Service. Importantly, You retain ownership of any Content You create, post, or display on or through the Service, and You are responsible for protecting Your rights to that Content.

This license also allows Us to share Your Content with other users of the Service, who may interact with it as permitted under these Terms. By posting Content, You represent and warrant that:

1.  You own the Content or have all necessary rights to use it and grant Us the rights outlined in these Terms.

2.  Your Content does not violate any applicable laws or infringe on any third party's rights, including privacy, publicity, copyrights, or contract obligations.

## Content Restrictions:

The Company does not control the Content generated or posted by users. You expressly acknowledge that You are solely responsible for all Content associated with Your account, including any activity conducted by third parties using Your account.

You may not generate, post, or transmit Content that is unlawful, offensive, or otherwise violates these Terms. Prohibited Content
includes but is not limited to:

- **Illegal Content or Activities**:

Content promoting illegal behavior or violating applicable laws.

- **Automated or Bot-generated Content**:

Automated article spinning, bot-like generation, or similar practices.

- **Defamatory or Discriminatory Material**:

Content that is defamatory, discriminatory, or mean-spirited, especially if targeting religion, race, sexual orientation, gender, national/ethnic origin, or other groups.

- **Restricted Categories**: Content involving substance abuse, adult
  services, or similar restricted topics.

- **Spam or Unauthorized Solicitation**: Unsolicited advertising,
  chain letters, lotteries, or gambling-related Content.

- **Malicious Software or Code**:

Viruses, malware, or any Content designed to harm software, hardware, or telecommunications systems.

- **Intellectual Property Infringement**:

Content that violates patents, trademarks, copyrights, trade secrets, or publicity rights.

- **Impersonation or Fraud**:

Misrepresentation of identity or affiliation, including impersonating the Company or its employees.

- **Privacy Violations**:

Sharing private or sensitive information without consent.

- **Misinformation**: Content that is knowingly false or misleading.

The Company reserves the right to evaluate and remove Content or limit its use if it violates these Terms. Additionally, we may edit, format, or adjust Content to ensure compliance with our standards. Users who violate these Terms may face suspension or termination of their accounts.

While the Company strives to moderate Content, we cannot monitor all user submissions. By using the Service, You agree that You may encounter Content You find objectionable. Under no circumstances will the Company be held liable for such Content, including any errors, omissions, or damages arising from Your interaction with it.

## Prohibited Activities:

In connection with the Service, You are prohibited from engaging in the
following activities:

- Using the Service to gather passwords, account credentials, or sensitive information from other users.
- Engaging in activities that compromise network security, such as cracking passwords or distributing illegal material.
- Running automated processes (e.g., spam bots, auto-responders) that overload the system.
- Scraping, crawling, or reverse-engineering any part of the Service.
- Violating intellectual property laws or attempting to decompile the Service's source code.

Fraudulent, abusive, or illegal activities may result in immediate account suspension or termination.

## Content Backups:

Although the Company performs regular backups, We cannot guarantee that all Content will be preserved or restored without corruption. Causes for potential data issues include:

- Corrupted data at the time of backup.
- Data modifications during the backup process.

The Company will make every effort to address known issues with backups and restore Content if possible. However, You agree that the Company is not liable for lost or corrupted data.

To safeguard Your Content, You are encouraged to maintain independent backups of any data You post or create on the Service.

By using the Service, You agree to these Content guidelines and the associated responsibilities. Adhering to these standards not only ensures a safe and fair environment for all users but also allows the Company to provide high-quality, reliable services.

# **Copyright Policy:**

We respect the intellectual property rights of others. It is our policy to respond to any claim that content posted on our Service infringes on the copyright or other intellectual property rights of any person. If you are a copyright owner or are authorized to act on behalf of one, and you believe that copyrighted work has been copied in a way that constitutes infringement through the Service, please submit a written notice to our copyright agent via email at ** [support@osllm.ai](mailto:support@osllm.ai)**. Your notice should include a detailed description of the alleged infringement. Please note that you may be held accountable for damages (including costs and attorneys' fees) for knowingly misrepresenting that any content infringes your copyright.

We have adopted the following general policy toward copyright infringement in accordance with the **Digital Millennium Copyright Act
(DMCA)** (available at[www.lcweb.loc.gov/copyright/legislation/dmca.pdf](%20https://www.copyright.gov/legislation/dmca.pdf)):

## General Policy

1.  It is our policy to:

    - Remove or disable access to material that we believe in good  faith is copyrighted material copied and distributed without  authorization.
    - Terminate services to repeat offenders of this policy.

2.  **Designated Agent**: The address and contact details of the
    Company's Designated Agent to receive notifications of claimed
    infringement are provided at the end of this section.

## Procedure for Reporting Copyright Infringements:

If you believe that material or content residing on or accessible through our Service infringes on a copyright, please provide a notice of copyright infringement containing the following information to our Designated Agent:

1.  A physical or electronic signature of a person authorized to act on behalf of the copyright owner.
2.  Identification of the copyrighted work(s) alleged to have been infringed.
1.  Identification of the material that is claimed to be infringing, including information sufficient to locate the material within the Service.
2.  Contact information for the notifier, including address, telephone number, and, if available, email address.
3.  A statement that the notifier has a good faith belief that the material identified is not authorized by the copyright owner, its
 agent, or the law.
4.  A statement under penalty of perjury that the information provided  is accurate and that the notifier is authorized to act on behalf of  the copyright owner.

## Response to Proper Notice of Claimed Infringement:

Upon receipt of a bona fide infringement notification, it is our policy
to:

1.  Remove or disable access to the material that is alleged to be infringing.
2.  Notify the content provider, member, or user that the material has  been removed or access to it has been disabled.
3.  Terminate access for repeat offenders.

## Procedure to File a Counter-Notice:

If you, as a content provider, member, or user, believe that the
material removed or disabled is not infringing, or that you have the
legal right to post and use such material, you may submit a
counter-notice to our Designated Agent. The counter-notice must include:

1.  A physical or electronic signature of the content provider, member, or user.
2.  Identification of the material that was removed or to which access was disabled, and the location where the material appeared before it was removed or disabled.
3.  A statement, under penalty of perjury, that you have a good faith belief that the material was removed or disabled due to a mistake or misidentification.
4.  Your name, address, telephone number, and, if available, email address.
5.  A statement that you consent to the jurisdiction of the federal court in your judicial district (or any judicial district in which the Company is located, if outside the United States) and agree to accept service of process from the party who submitted the original infringement notice.

Upon receiving a counter-notice:

- We may send a copy to the original complaining party to inform them that the removed material may be replaced or access to it restored.
- Unless the copyright owner files an action seeking a court order against the content provider, member, or user, we may replace the
 removed material or restore access to it within 10--14 business days after receipt of the counter-notice, at our discretion.

# Intellectual Property:

**Intellectual Property Ownership.** The Software is licensed as explained above and not sold to you under this Agreement, and you acknowledge that OS LLM AI and its licensors retain all title, ownership rights, and Intellectual Property Rights in and to the Software. We reserve all rights not expressly granted herein to the Software.

**OS LLM AI Content.**

Except for the User Content (as defined in clause 5.3 below), the:

1. Content on the Software, including, without limitation, the text, information, documents, descriptions, products, software, graphics, photos, sounds, videos, interactive features, and services (the Materials);

2. The trademarks, service marks, and logos contained therein (Marks, and together with the Materials, the OS LLM AI Content), are the property of OS LLM AI and/or its licensors and may be protected by applicable copyright or other intellectual property laws and treaties.

OS LLM AI and the OS LLM AI logo are Marks of OS LLM AI and its affiliates.

**User Content and Use Derived Content.** You are solely responsible for
all interactions, text, documents, or other content or information uploaded, entered, or otherwise transmitted by you in connection with your use of the Services and/or Software (User Content) and the User Derived Content (as defined below). User Content and/or User Derived Content may include, among other things, mistakes, typos, wording, and text contained in the content or information transmitted by you. To the maximum extent permitted by law, OS LLM AI shall have no liability to you with respect to the User Content and/or the User Derived Content, including, without limitation, liability with respect to:

1. any information (including your confidential information) contained in or apparent from any User Content and/or the User Derived Content; and/or

2. any copyright infringement claim or another infringement claim by a third party in relation to or in connection with the User Content and/or the User Derived Content.

You warrant, represent, and covenant that:

1. you own or have a valid and enforceable license and all the necessary rights to use, submit or transmit all User Content and use the Service and the Software;

2. no User Content or User Derived Content (as defined bel) infringes, misappropriates, or violates, or will infrin, misappropriate, or violate, the rights (including, witht limitation, any copyrights or other intellectual property rights) oany person or entity or any applicable law, rule, or regulation of angovernment authority of competent jurisdiction;

3. all summaries, content, or text derived or extracted from the User Content using the Summarization Service and/or Software (User Derived Content) shall be used by the User for personal use only; and (iv) the User shall not disseminate or distribute the User Content or User Derived Content in breach of any applicable law or third party's intellectual property rights or other rights.

You acknowledge that the Services and the Software do not operate as an archive or file storage service. You are solely responsible for the backup of User Content and other safeguards appropriate for your needs. You retain all right, title, and interest in and to your User Content.

To the maximum extent permitted by law, by uploading or entering any User Content, you give OS LLM AI (and those it works with) a nonexclusive, worldwide, royalty-free and fully-paid, transferable, and sub-licensable, perpetual, and irrevocable license to copy, store, and use your User Content in order to:

1. provide the Software and Services;

2. administer and make improvements to the Software and Services (including improving the algorithms underlying the Software and the Services); and

3. collect and analyze anonymous information.

To the extent that User Content contains any third-party data, you hereby warrant to have obtained all required consents from such third party to allow OS LLM AI to use the User Content as set forth above.

**Feedback.** If OS LLM AI receives any feedback (e.g., questions,
comments, suggestions, or the like) regarding any of the Services and/or Software (collectively, Feedback), all rights, including Intellectual Property Rights, in such Feedback shall belong exclusively to OS LLM AI and shall be considered OS LLM AI's Confidential Information. You hereby irrevocably, fully, and unconditionally transfer and assign to OS LLM AI all Intellectual Property Rights and remaining rights you have in such Feedback, without any further step or payment being necessary, and waive any and all moral rights you may have in respect thereto, and the right to assert or take legal action in connection with such rights.

It is further understood that use of Feedback, if any, may be made by OS LLM AI at its sole discretion, and that OS LLM AI in no way
shall be obliged to make use of any kind of Feedback or part thereof.

# Links to Other Websites:

Our Service may include links to third-party websites or services that are not owned or controlled by the Company.

The Company has no control over and assumes no responsibility for the content, privacy policies, or practices of any third-party websites or services. You acknowledge and agree that the Company is not responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such websites or services.

We strongly recommend that you review the terms and conditions and privacy policies of any third-party websites or services you visit.

# Termination :

We reserve the right to terminate or suspend your Account immediately, without prior notice or liability, for any reason, including but not limited to a breach of these Terms and Conditions.

Upon termination, your right to use the Service will end immediately. If you wish to terminate your Account, you may simply discontinue using the Service. This Agreement will remain in effect as long as you use the Services.

You may terminate your use of the Services at any time. The Company may, at its sole discretion, terminate or suspend your access to the Services or your membership at any time, for any reason, and without prior notice, which may result in the forfeiture and destruction of all information associated with your membership.

The Company may also terminate or suspend all Services and access to the App immediately and without prior notice if you breach any terms or conditions of this Agreement. Upon termination of your account, your right to use the Services, access the App, and any associated Content will immediately cease.

In such cases, the Company reserves the right to refund your transactions or hold your funds for a period of up to 180 days from the date of termination, after which they may be released to your account.

All provisions of this Agreement that, by their nature, should survive termination, will remain in effect after termination. These provisions include, but are not limited to, ownership provisions, warranty disclaimers, and limitations of liability.



# Indemnity:

You agree to indemnify and hold the Company, its parents, subsidiaries, affiliates, officers, and employees harmless from any and all claims or demands made by third parties arising out of or related to your access to or use of the Services, your violation of this Agreement, or the infringement by you or anyone using your account of any intellectual property or other rights of any person or entity. This includes, without limitation, all damages, liabilities, settlements, costs, and attorneys' fees.

# Limitation of Liability:

To the fullest extent permissible by law, and notwithstanding anything to the contrary in this Agreement, in no event shall either party, its affiliates, or any licensor or supplier of the Company be liable under or in connection with this Agreement for:

1. Any consequential, indirect, special, incidental, or punitive damages;

2. Any loss of profits, business, revenue, anticipated savings, or wasted expenditure;

3. Any loss of or damage to data, networks, information systems, reputation, or goodwill; or

4. The cost of procuring substitute goods or services.

To the maximum extent permitted by law, the combined aggregate liability of the Company and its affiliates under or in connection with this Agreement, the Software, and the Service shall not exceed the amount actually paid by you to the Company under this Agreement in the three (3) months preceding the date giving rise to the liability.

These exclusions and limitations apply:

1. to the maximum extent allowed by applicable law;

2. even if a party was advised or should have been aware of the possibility of such damages;

3. even if any remedy in this Agreement fails of its essential purpose; and

4. regardless of the theory or basis of liability, including but not limited to contract, tort (including negligence or breach of statutory duty), misrepresentation, restitution, or otherwise.

## Disclaimer:

To the maximum extent permitted by law, you acknowledge that the Service, the Company Content, and any related goods or services provided (collectively, the Company Materials) are provided on an as is and as available basis, with all faults and without any warranties, guarantees, or conditions of any kind. This includes but is not limited to express, implied, or statutory warranties or conditions such as merchantability, satisfactory quality, fitness for a particular purpose, non-infringement, title, or reliability, all of which are disclaimed by the Company, its suppliers, and licensors.

To the maximum extent permitted by law, the Company and its licensors make no representations, warranties, or guarantees regarding:

1. the effectiveness, reliability, completeness, timeliness, or quality of the Company Materials, the Services, or the Software;

2. uninterrupted, secure, or error-free use of the Company Materials, Services, or Software;

3. the operation of networks, data transmission, or connectivity issues; or

4. compliance with laws, regulations, or other standards.

The Company does not warrant that the content available on or generated by the Software or Service is accurate, complete, or error-free, or that the Service or Software is free of viruses or harmful code. The Company reserves the right to make changes to the content, Software, and/or Services at any time without notice.

The Company will not be liable for delays, interruptions, service failures, or issues related to internet use, public networks, or hosting providers. You assume all risks and costs associated with using the Software or Service and agree that the Company is not responsible for any consequences, including technical problems such as slow connections, traffic congestion, or server overloads. Applicable law may not allow the exclusion of certain warranties. To the extent that such exclusions are not allowed, they may not apply to you.

# Governing Law:

The laws of the Country, excluding its conflict of law rules, shall govern these Terms and your use of the Service. Your use of the Application may also be subject to local, state, national, or international laws.

# Disputes Resolution:

If you have any concerns or disputes regarding the Service, you agree to cirst attempt to resolve the dispute informally by contacting the company.

**For European Union (EU) Users:**

If you are a European Union consumer, you will benefit from any mandatory provisions of the law of the country in which you reside.

United States Federal Government End Use Provisions:
If you are a U.S. federal government end user, our Service is classified as a Commercial Item, as defined in 48 C.F.R. §2.101.

United States Legal Compliance:

You represent and warrant that:

1. You are not located in a country subject to a United States  government embargo or designated by the United States government as a  terrorist-supporting country; and
2. You are not listed on any United States government list of prohibited or restricted parties.

# Severability and Waiver:

## Severability:

If any provision of these Terms is found to be unenforceable or invalid, such provision will be modified and interpreted to accomplish its objectives to the greatest extent possible under applicable law, and the remaining provisions will remain in full force and effect.

## Waiver:

Except as explicitly stated herein, the failure to exercise a right or enforce an obligation under these Terms shall not affect a party's ability to exercise such right or enforce such obligation at any time thereafter, nor shall a waiver of any breach constitute a waiver of any subsequent breach.

## Translation Interpretation:

These Terms and Conditions may have been translated if made available to you in another language on our Service. In the event of a dispute, the original English version shall prevail.

## Changes to These Terms and Conditions:

We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will make reasonable efforts to provide at least 30 days' notice before the new terms take effect. The determination of what constitutes a material change will be made at our sole discretion. By continuing to access or use our Service after the revisions become effective, you agree to be bound by the updated Terms. If you do not agree to the revised Terms, either in whole or in part, you must stop using the Service and website.

- **Contact Us**: If you have any questions about these Terms and Conditions, you can
- contact us at
- **Company** (referred to as the Company, We, Us, or Our)
- refers to: **Durabuy American Import Export LLC**
- **Address**: 7343 N Teutonia Ave Unit 7, Milwaukee, WI 53209, United States
- **Phone**: +1 (971) 400-2132
- **Website**: <https://osllm.ai>
- **Email**: [support@osllm.ai](mailto:support@osllm.ai)
"
            color: Style.Colors.textInformation
            anchors.fill: parent
            anchors.margins: 10
            selectionColor: "blue"
            selectedTextColor: "white"
            font.pixelSize: 14
            width: parent.width
            focus: false
            readOnly: true
            clip: true
            horizontalAlignment: Text.AlignJustify
            wrapMode: TextEdit.Wrap
            textFormat: TextEdit.MarkdownText
            onLinkActivated: function(link) {
                Qt.openUrlExternally(link)
            }
            Accessible.role: Accessible.Button
            Accessible.name: text
            Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
        }
    }
}
