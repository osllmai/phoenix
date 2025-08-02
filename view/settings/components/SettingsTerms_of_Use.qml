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

        TextArea {
            id: textId
            textFormat: TextEdit.RichText
            wrapMode: TextEdit.Wrap
            readOnly: true
            // clip: true
            focus: false
            horizontalAlignment: Text.AlignJustify
            width: parent.width
            anchors.fill: parent
            anchors.margins: 10
            color: Style.Colors.textInformation
            font.pixelSize: 14
            selectionColor: "blue"
            selectedTextColor: "white"
            text: "<h1>Terms of Use:</h1>
<p><b>Established &amp; Effective Date:</b> January 01, 2024<br><b>Update:</b> April 26, 2025</p>
<p>Please read these terms of use (agreement) carefully before using the services offered by Durabuy American Import Export LLC (Company). By visiting the website <a href='https://osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>https://osllm.ai</a> and/or using the services in any manner, you agree that you have read, understood, and accept to be bound by these terms and conditions. If the terms of this agreement are considered an offer, acceptance is expressly limited to such terms. If you do not unconditionally agree to all the terms and conditions of this agreement, you have no right to use the website <a href='https://osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>https://osllm.ai</a>, applications, extensions, or services provided by OS LLM. Use of the Company's services is expressly conditioned upon your acceptance of these terms.</p>
<ul>
<li><b>Country refers to:</b> United States</li>
<li><b>Country:</b> United States</li>
<li><b>Website:</b> <a href='https://osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;' >osllm.ai</a></li>
<li><b>Email:</b> <a href='mailto:support@osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>support@osllm.ai</a></li>
</ul>

<h2>Children's Privacy:</h2>
<p>The Company does not knowingly collect or solicit personal information from anyone under the age of 13, nor does it knowingly allow such individuals to register for the Services. If you are under 13 years of age, please do not attempt to register for the Services or provide any personal information to us, including your name, address, telephone number, or email address. No person under the age of 13 may provide any personal information to the Company or through the Services. In the event that the Company becomes aware that it has collected personal information from a child under age 13 without verifying parental consent, the Company will delete that information promptly. If you believe that the Company might have any information from or about a child under 13, please contact us at <a href='mailto:support@osllm.ai'color:" + Style.Colors.textInformation + "; text-decoration:none;'>support@osllm.ai</a>.</p>

<h2>User Representations and Warranties:</h2>
<p>By accessing or using the Services, you represent and warrant to the Company that:</p>
<ol>
<li><b>Legal Capacity:</b><br>You are of legal age to form a binding contract with the Company and are not prohibited by law from accessing or using the Services.</li>
<li><b>Accurate Information:</b><br>All registration information you submit is accurate, current, and truthful.</li>
<li><b>Maintenance of Information:</b><br>You will maintain the accuracy of such information and promptly update it as necessary.</li>
</ol>
<p>Additionally, you certify that you are legally permitted to use and access the Services and take full responsibility for your selection, use, and access to the Services. This Agreement is void where prohibited by law, and the right to access the Services is revoked in such jurisdictions.</p>

<h3>Placing Orders for Goods:</h3>
<p>By placing an order for goods through our Service, you confirm that you are legally capable of entering into binding contracts.</p>

<h3>Your Information:</h3>
<p>When you place an order for goods available on our Service, we may request certain information necessary to process your order. This information may include, but is not limited to:</p>
<ul>
<li>Your name</li>
<li>Your email address</li>
<li>Your phone number</li>
<li>Your credit card number</li>
<li>The expiration date of your credit card</li>
<li>Your billing address</li>
<li>Your shipping information</li>
</ul>
<p>You represent and warrant that:</p>
<ol>
<li>You have the legal right to use any credit or debit card(s) or other payment method(s) associated with your order.</li>
<li>All information you provide to us is true, correct, and complete.</li>
</ol>
<p>By submitting your information, you authorize us to share it with third-party payment processors solely for the purpose of completing your order.</p>

<h3>Order Cancellation:</h3>
<p>We reserve the right to refuse or cancel your order at any time for specific reasons, including but not limited to:</p>
<ol>
<li><b>Goods Availability:</b> If the goods you ordered are unavailable.</li>
<li><b>Pricing Errors:</b> If there are errors in the description or pricing of the goods.</li>
<li><b>Order Errors:</b> If there are errors in your order details.</li>
</ol>

<h3>Protection Against Abnormal User Behavior</h3>
<p>To ensure fairness and maintain the normal operation of our services, we monitor and take measures against abnormal user behavior. If a user's conduct violates our Terms of Use or Code of Conduct, such as:</p>
<ol>
<li><b>Manipulating Membership Status:</b> Attempting to manipulate membership status through improper means.</li>
<li><b>Disruptive Cancellations:</b> Intentionally making repetitive cancellations to disrupt service operations.</li>
<li><b>Exploiting System Vulnerabilities:</b> Attempting to exploit system vulnerabilities to obtain undue benefits.</li>
<li><b>Account Sharing or Reselling:</b> Violating the single-account user principle by reselling or sharing the account with multiple users.</li>
</ol>
<p>We reserve the right to immediately terminate or suspend the user's membership and/or right to use the services. In such cases, a refund may not be offered. Each situation will be assessed on a case-by-case basis to ensure a fair and safe environment for all users.</p>

<h1>Availability, Errors, and Inaccuracies:</h1>
<p>We are constantly updating our offerings of Goods on the Service. However, the Goods available on our Service may be mispriced, described inaccurately, or unavailable. We may also experience delays in updating information regarding our Goods on the Service and in our advertising on other websites.</p>
<p>We cannot and do not guarantee the accuracy or completeness of any information, including prices, product images, specifications, availability, and services. We reserve the right to change or update information and to correct errors, inaccuracies, or omissions at any time without prior notice.</p>

<h2>Prices Policy:</h2>
<p>The Company reserves the right to revise its prices at any time prior to accepting an Order.</p>
<p>Prices quoted may be revised by the Company after accepting an Order in the event of occurrences affecting delivery, such as government actions, variations in customs duties, increased shipping charges, higher foreign exchange costs, or any other matter beyond the Company's control. In such cases, you have the right to cancel your Order.</p>

<h2>Payments:</h2>
<p>Payments can be made through valid credit or debit cards and are subject to validation checks and authorization by your card issuer. If we do not receive the required authorization, we will not be liable for any delay or non-delivery of your Order.</p>

<h1>Subscriptions:</h1>

<h2>Subscription Period:</h2>
<p>The Service, or certain parts of it, are available only with a paid Subscription. You will be billed in advance on a recurring and periodic basis, either monthly or yearly, depending on the Subscription plan you select when purchasing the Subscription. At the end of each period, your Subscription will automatically renew under the same conditions unless you cancel it or the Company cancels it.</p>

<h2>Subscription Cancellations:</h2>
<p>You may cancel your Subscription renewal by contacting us at <a href='mailto:support@osllm.ai' style='color:" + Style.Colors.textInformation + "; text-decoration:none;'>support@osllm.ai</a> or through the dashboard. You will not receive a refund for fees already paid for the current Subscription period, and you will be able to access the Service until the end of your current Subscription period.</p>

<h1>Billing:</h1>

<p>You must provide the Company with accurate and complete billing information, including your full name, address, state, zip code, telephone number, and valid payment method information.</p>

<p>If automatic billing fails for any reason, the Company will issue an electronic invoice indicating that you must proceed manually, by the specified deadline, with the full payment corresponding to the billing period as indicated on the invoice.</p>

<h2>Fee Changes:</h2>

<p>The Company may modify Subscription fees at any time in its sole discretion. Any Subscription fee changes will become effective at the end of the current Subscription period.</p>

<p>The Company will provide you with reasonable prior notice of any changes to Subscription fees, giving you the opportunity to terminate your Subscription before the changes take effect.</p>

<p>Your continued use of the Service after the Subscription fee change comes into effect constitutes your agreement to pay the modified Subscription fee amount.</p>

<h1>Refunds:</h1>

<p>We have established different refund policies based on subscription type, add-on package type, regional laws, and account status.</p>

<h2>Refund Process:</h2>

<p>After you submit a refund request, we will manually review your order and send the review results or request additional information via the email you provided within 48 hours to five business days. Please ensure you check your email, including your spam folder, to avoid missing any important communications. Follow the instructions in the email carefully. If you fail to complete the next steps within the specified timeframe, we will be unable to process your refund.</p>

<h2>EU or Turkey Customers:</h2>

<p>If you reside in the EU or Turkey, you are eligible to cancel your subscription and receive a refund within 4 days of purchase. This applies to both monthly and annual subscriptions. Please specify in your refund request that you are applying for a refund under EU or Turkey regulations. If there are any irregularities with your account, OS LLM ai customer service may require you to provide relevant proof when processing your refund request.</p>

<h2>All Other Customers:</h2>

<p>While we strive to make our refund policy as fair as possible, OS LLM ai may not be able to fulfill your refund request if there are irregularities with your account.</p>

<ul>
<li>Monthly Subscriptions: You can apply for a refund within 24 hours after the purchase charge. Please state the reason for your refund request in your application.</li>
<li>Annual Subscriptions: Subscribers can apply for a full refund within 72 hours after the initial purchase charge date and time. No refunds will be granted for requests made after this period.</li>
</ul>

<h2>Advanced Credits Add-on Package:</h2>

<p>The Advanced Credits Add-on Package is a specific type of value-added benefit and is non-refundable once purchased. According to our Terms of Service:</p>

<ul>
<li>Unused Advanced Credits: Remain valid from the date of purchase and  can be used while the membership subscription is active. The amount paid  is non-refundable.</li>
<li>Abnormal Situations: If you encounter abnormal situations such as restricted account access while using Advanced Credits, we will initiate an account risk assessment procedure. The assessment results will determine the subsequent course of action:</li>
</ul>

<ol>
<li>Normal Use: If your account is deemed to be in normal use, we will promptly restore access and ensure the continued validity of your Advanced Credits. No refunds will be offered in such cases.</li>
<li>Risk Control Violations: If the assessment confirms that the account has been banned due to triggering risk control mechanisms, we will be unable to restore your access privileges, and no refund will be provided.</li>
</ol>

<h2>Additional Conditions:</h2>

<ul>
<li>First Purchase Refunds Only: Refunds will only be processed for the first purchase. Subsequent purchases are not eligible for refunds.</li>
<li>Usage Threshold: If you have used 10% or more of your purchased credits, we reserve the right not to issue a refund.</li>
<li>Previous Refunds: If you have previously received a refund for our services, we reserve the right to deny subsequent refund requests. This policy is designed to prevent abuse of our refund system and ensure the fair use of our services.</li>
</ul>

<p>If you need to inquire about refund-related issues, please follow the refund process outlined above to communicate with us via email. We recommend users carefully consider their usage needs before purchasing an Advanced Credits Add-on Package to ensure full utilization of the purchased credits.</p>

<h1>Promotions:</h1>

<p>Promotions available through the Service may be subject to separate rules from these Terms. If you choose to participate in any Promotions, please review the applicable rules and our Privacy Policy. In the event of a conflict between the Promotion rules and these Terms, the Promotion rules will take precedence.</p>

<h1>User Accounts:</h1>

<p>When you create an account with us, you must provide accurate, complete, and current information at all times. Failure to do so constitutes a breach of the Terms, which may result in the immediate termination of your account on our service.</p>

<p>You are responsible for safeguarding the password you use to access the service and for any activities or actions under your password, whether your password is with our service or a third-party social media service.</p>

<p>You agree not to disclose your password to any third party. You must notify us immediately upon becoming aware of any security breach or unauthorized use of your account.</p>

<p>You may not use as a username the name of another person or entity, a name that is not lawfully available for use, a name or trademark that is subject to any rights of another person or entity without appropriate authorization, or a name that is offensive, vulgar, or obscene.</p>

<p>We permit only one account per user. Additionally, you may only log into your account on up to ten devices. If you attempt to create multiple accounts, exceed the device limit, or violate our fair usage policy, we reserve the right to remove your data and restrict your access to our service.</p>

<h1><b>Strengthening OS LLM ai Usage Regulations and Combating Illegal Third-party Activities:</b></h1>

<p>In order to maintain the fairness, security, and sustainable development of OS LLM ai, ensure that all users can enjoy high-quality services, and comprehensively protect user account security and privacy data, we have established this policy.</p>

<p>We explicitly prohibit the following behaviors: subscribing through unofficial channels such as third-party payment platforms, account sharing or reselling, circumventing our security measures through technical means, and any behavior that violates our Terms of Service.</p>

<p>For users who violate the above regulations or related parties who illegally profit, we will take severe measures, including immediately suspending or terminating the relevant accounts, canceling all illegally obtained benefits, and reserving the right to pursue legal liability.</p>

<p>To more effectively identify and prevent abnormal behavior, we have further upgraded OS LLM ai's account security risk control system while ensuring that the rights of normal users are not affected. We understand that misjudgments may occur during the implementation process, so we provide a dedicated appeal channel. If you believe your account has been incorrectly processed, please contact us via email: <a href=\"mailto:support@osllm.ai\" style=\"color: " + Style.Colors.textInformation + "; text-decoration:none;\">support@osllm.ai</a>. The OS LLM ai Security Team will carefully and impartially review each appeal case.</p>

<p>We strongly recommend that all users purchase and use our services through official channels. This not only ensures that your rights are fully protected but is also the best way to support our continued provision of high-quality services. We appreciate every user who abides by the rules; your support enables our platform to thrive healthily.</p>

<h1><b>Content Policy:</b></h1>

<h2>Your Right to Create and Post Content.</h2>

<p>Our Service enables You to generate and post Content. You are solely responsible for the Content You create using the AI Service, including its legality, reliability, and appropriateness.</p>

<p>By generating and posting Content to the Service, you grant us a global, non-exclusive, royalty-free right and license to use, modify, publicly perform, publicly display, reproduce, and distribute such Content within and through the Service. Importantly, You retain ownership of any Content You create, post, or display on or through the Service, and You are responsible for protecting Your rights to that Content.</p>

<p>This license also allows Us to share Your Content with other users of the Service, who may interact with it as permitted under these Terms. By posting Content, You represent and warrant that:</p>

<ol>
<li>You own the Content or have all necessary rights to use it and grant Us the rights outlined in these Terms.</li>
<li>Your Content does not violate any applicable laws or infringe on any third party's rights, including privacy, publicity, copyrights, or contract obligations.</li>
</ol>

<h2>Content Restrictions:</h2>

<p>The Company does not control the Content generated or posted by users. You expressly acknowledge that You are solely responsible for all Content associated with Your account, including any activity conducted by third parties using Your account.</p>

<p>You may not generate, post, or transmit Content that is unlawful, offensive, or otherwise violates these Terms. Prohibited Content includes but is not limited to:</p>

<ul>
<li><b>Illegal Content or Activities</b>: Content promoting illegal behavior or violating applicable laws.</li>
<li><b>Automated or Bot-generated Content</b>: Automated article spinning, bot-like generation, or similar practices.</li>
<li><b>Defamatory or Discriminatory Material</b>: Content that is defamatory, discriminatory, or mean-spirited, especially if targeting religion, race, sexual orientation, gender, national/ethnic origin, or other groups.</li>
<li><b>Restricted Categories</b>: Content involving substance abuse, adult services, or similar restricted topics.</li>
<li><b>Spam or Unauthorized Solicitation</b>: Unsolicited advertising, chain letters, lotteries, or gambling-related Content.</li>
<li><b>Malicious Software or Code</b>: Viruses, malware, or any Content designed to harm software, hardware, or telecommunications systems.</li>
<li><b>Intellectual Property Infringement</b>: Content that violates patents, trademarks, copyrights, trade secrets, or publicity rights.</li>
<li><b>Impersonation or Fraud</b>: Misrepresentation of identity or affiliation, including impersonating the Company or its employees.</li>
<li><b>Privacy Violations</b>: Sharing private or sensitive information without consent.</li>
<li><b>Misinformation</b>: Content that is knowingly false or misleading.</li>
</ul>

<p>The Company reserves the right to evaluate and remove Content or limit its use if it violates these Terms. Additionally, we may edit, format, or adjust Content to ensure compliance with our standards. Users who violate these Terms may face suspension or termination of their accounts.</p>

<p>While the Company strives to moderate Content, we cannot monitor all user submissions. By using the Service, You agree that You may encounter Content You find objectionable. Under no circumstances will the Company be held liable for such Content, including any errors, omissions, or damages arising from Your interaction with it.</p>

<h2>Prohibited Activities:</h2>\
<p>In connection with the Service, You are prohibited from engaging in the following activities:</p>\
<ul>\
<li>Using the Service to gather passwords, account credentials, or sensitive information from other users.</li>\
<li>Engaging in activities that compromise network security, such as cracking passwords or distributing illegal material.</li>\
<li>Running automated processes (e.g., spam bots, auto-responders) that overload the system.</li>\
<li>Scraping, crawling, or reverse-engineering any part of the Service.</li>\
<li>Violating intellectual property laws or attempting to decompile the Service's source code.</li>\
</ul>\
<p>Fraudulent, abusive, or illegal activities may result in immediate account suspension or termination.</p>\
<h2>Content Backups:</h2>\
<p>Although the Company performs regular backups, We cannot guarantee that all Content will be preserved or restored without corruption. Causes for potential data issues include:</p>\
<ul>\
<li>Corrupted data at the time of backup.</li>\
<li>Data modifications during the backup process.</li>\
</ul>\
<p>The Company will make every effort to address known issues with backups and restore Content if possible. However, You agree that the Company is not liable for lost or corrupted data.</p>\
<p>To safeguard Your Content, You are encouraged to maintain independent backups of any data You post or create on the Service.</p>\
<p>By using the Service, You agree to these Content guidelines and the associated responsibilities. Adhering to these standards not only ensures a safe and fair environment for all users but also allows the Company to provide high-quality, reliable services.</p>\
<h1><strong>Copyright Policy:</strong></h1>\
<p>We respect the intellectual property rights of others. It is our policy to respond to any claim that content posted on our Service infringes on the copyright or other intellectual property rights of any person. If you are a copyright owner or are authorized to act on behalf of one, and you believe that copyrighted work has been copied in a way that constitutes infringement through the Service, please submit a written notice to our copyright agent via email at <a href=\"mailto:support@osllm.ai\" style=\"color: " + Style.Colors.textInformation + "\">support@osllm.ai</a>. Your notice should include a detailed description of the alleged infringement. Please note that you may be held accountable for damages (including costs and attorneys' fees) for knowingly misrepresenting that any content infringes your copyright.</p>\
<p>We have adopted the following general policy toward copyright infringement in accordance with the <strong>Digital Millennium Copyright Act (DMCA)</strong> (available at <a href=\"https://www.copyright.gov/legislation/dmca.pdf\" style=\"color: " + Style.Colors.textInformation + "\">www.lcweb.loc.gov/copyright/legislation/dmca.pdf</a>):</p>\
<h2>General Policy</h2>\
<ol>\
<li>It is our policy to:</li>\
<ul>\
<li>Remove or disable access to material that we believe in good faith is copyrighted material copied and distributed without authorization.</li>\
<li>Terminate services to repeat offenders of this policy.</li>\
</ul>\
<li><strong>Designated Agent</strong>: The address and contact details of the Company's Designated Agent to receive notifications of claimed infringement are provided at the end of this section.</li>\
</ol>\
<h2>Procedure for Reporting Copyright Infringements:</h2>\
<p>If you believe that material or content residing on or accessible through our Service infringes on a copyright, please provide a notice of copyright infringement containing the following information to our Designated Agent:</p>\
<ol>\
<li>A physical or electronic signature of a person authorized to act on behalf of the copyright owner.</li>\
<li>Identification of the copyrighted work(s) alleged to have been infringed.</li>\
<li>Identification of the material that is claimed to be infringing, including information sufficient to locate the material within the Service.</li>\
<li>Contact information for the notifier, including address, telephone number, and, if available, email address.</li>\
<li>A statement that the notifier has a good faith belief that the material identified is not authorized by the copyright owner, its agent, or the law.</li>\
<li>A statement under penalty of perjury that the information provided is accurate and that the notifier is authorized to act on behalf of the copyright owner.</li>\
</ol>\
<h2>Response to Proper Notice of Claimed Infringement:</h2>\
<p>Upon receipt of a bona fide infringement notification, it is our policy to:</p>\
<ol>\
<li>Remove or disable access to the material that is alleged to be infringing.</li>\
<li>Notify the content provider, member, or user that the material has been removed or access to it has been disabled.</li>\
<li>Terminate access for repeat offenders.</li>\
</ol>\
<h2>Procedure to File a Counter-Notice:</h2>\
<p>If you, as a content provider, member, or user, believe that the material removed or disabled is not infringing, or that you have the legal right to post and use such material, you may submit a counter-notice to our Designated Agent. The counter-notice must include:</p>\
<ol>\
<li>A physical or electronic signature of the content provider, member, or user.</li>\
<li>Identification of the material that was removed or to which access was disabled, and the location where the material appeared before it was removed or disabled.</li>\
<li>A statement, under penalty of perjury, that you have a good faith belief that the material was removed or disabled due to a mistake or misidentification.</li>\
<li>Your name, address, telephone number, and, if available, email address.</li>\
<li>A statement that you consent to the jurisdiction of the federal court in your judicial district (or any judicial district in which the Company is located, if outside the United States) and agree to accept service of process from the party who submitted the original infringement notice.</li>\
</ol>\
<p>Upon receiving a counter-notice:</p>\
<ul>\
<li>We may send a copy to the original complaining party to inform them that the removed material may be replaced or access to it restored.</li>\
<li>Unless the copyright owner files an action seeking a court order against the content provider, member, or user, we may replace the removed material or restore access to it within 10--14 business days after receipt of the counter-notice, at our discretion.</li>\
</ul>\
<h2>Intellectual Property:</h2>\
<p><strong>Intellectual Property Ownership.</strong> The Software is licensed as explained above and not sold to you under this Agreement, and you acknowledge that OS LLM AI and its licensors retain all title, ownership rights, and Intellectual Property Rights in and to the Software. We reserve all rights not expressly granted herein to the Software.</p>\
<p><strong>OS LLM AI Content.</strong></p>\
<ol>\
<li>Content on the Software, including, without limitation, the text, information, documents, descriptions, products, software, graphics, photos, sounds, videos, interactive features, and services (the Materials);</li>\
<li>The trademarks, service marks, and logos contained therein (Marks, and together with the Materials, the OS LLM AI Content), are the property of OS LLM AI and/or its licensors and may be protected by applicable copyright or other intellectual property laws and treaties.</li>\
</ol>\
<p>OS LLM AI and the OS LLM AI logo are Marks of OS LLM AI and its affiliates.</p>\
<p><strong>User Content and Use Derived Content.</strong> You are solely responsible for all interactions, text, documents, or other content or information uploaded, entered, or otherwise transmitted by you in connection with your use of the Services and/or Software (User Content) and the User Derived Content (as defined below). User Content and/or User Derived Content may include, among other things, mistakes, typos, wording, and text contained in the content or information transmitted by you. To the maximum extent permitted by law, OS LLM AI shall have no liability to you with respect to the User Content and/or the User Derived Content, including, without limitation, liability with respect to:</p>\
<ol>\
<li>any information (including your confidential information) contained in or apparent from any User Content and/or the User Derived Content; and/or</li>\
<li>any copyright infringement claim or another infringement claim by a third party in relation to or in connection with the User Content and/or the User Derived Content.</li>\
</ol>\
<p>You warrant, represent, and covenant that:</p>\
<ol>\
<li>you own or have a valid and enforceable license and all the necessary rights to use, submit or transmit all User Content and use the Service and the Software;</li>\
<li>no User Content or User Derived Content (as defined below) infringes, misappropriates, or violates, or will infringe, misappropriate, or violate, the rights (including, without limitation, any copyrights or other intellectual property rights) of any person or entity or any applicable law, rule, or regulation of any government authority of competent jurisdiction;</li>\
<li>all summaries, content, or text derived or extracted from the User Content using the Summarization Service and/or Software (User Derived Content) shall be used by the User for personal use only; and</li>\
<li>the User shall not disseminate or distribute the User Content or User Derived Content in breach of any applicable law or third party's intellectual property rights or other rights.</li>\
</ol>\
<p>You acknowledge that the Services and the Software do not operate as an archive or file storage service. You are solely responsible for the backup of User Content and other safeguards appropriate for your needs. You retain all right, title, and interest in and to your User Content.</p>\
<p>To the maximum extent permitted by law, by uploading or entering any User Content, you give OS LLM AI (and those it works with) a nonexclusive, worldwide, royalty-free and fully-paid, transferable, and sub-licensable, perpetual, and irrevocable license to copy, store, and use your User Content in order to:</p>\
<ol>\
<li>provide the Software and Services;</li>\
<li>administer and make improvements to the Software and Services (including improving the algorithms underlying the Software and the Services); and</li>\
<li>collect and analyze anonymous information.</li>\
</ol>\
<p>To the extent that User Content contains any third-party data, you hereby warrant to have obtained all required consents from such third party to allow OS LLM AI to use the User Content as set forth above.</p>\
<p><strong>Feedback.</strong> If OS LLM AI receives any feedback (e.g., questions, comments, suggestions, or the like) regarding any of the Services and/or Software (collectively, Feedback), all rights, including Intellectual Property Rights, in such Feedback shall belong exclusively to OS LLM AI and shall be considered OS LLM AI's Confidential Information. You hereby irrevocably, fully, and unconditionally transfer and assign to OS LLM AI all Intellectual Property Rights and remaining rights you have in such Feedback, without any further step or payment being necessary, and waive any and all moral rights you may have in respect thereto, and the right to assert or take legal action in connection with such rights.</p>\
<p>It is further understood that use of Feedback, if any, may be made by OS LLM AI at its sole discretion, and that OS LLM AI in no way shall be obliged to make use of any kind of Feedback or part thereof.</p>\
<h2>Links to Other Websites:</h2>\
<p>Our Service may include links to third-party websites or services that are not owned or controlled by the Company.</p>\
<p>The Company has no control over and assumes no responsibility for the content, privacy policies, or practices of any third-party websites or services. You acknowledge and agree that the Company is not responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such websites or services.</p>\
<p>We strongly recommend that you review the terms and conditions and privacy policies of any third-party websites or services you visit.</p>\
<h2>Termination :</h2>\
<p>We reserve the right to terminate or suspend your Account immediately, without prior notice or liability, for any reason, including but not limited to a breach of these Terms and Conditions.</p>\
<p>Upon termination, your right to use the Service will end immediately. If you wish to terminate your Account, you may simply discontinue using the Service. This Agreement will remain in effect as long as you use the Services.</p>\
<p>You may terminate your use of the Services at any time. The Company may, at its sole discretion, terminate or suspend your access to the Services or your membership at any time, for any reason, and without prior notice, which may result in the forfeiture and destruction of all information associated with your membership.</p>\
<p>The Company may also terminate or suspend all Services and access to the App immediately and without prior notice if you breach any terms or conditions of this Agreement. Upon termination of your account, your right to use the Services, access the App, and any associated Content will immediately cease.</p>\
<p>In such cases, the Company reserves the right to refund your transactions or hold your funds for a period of up to 180 days from the date of termination, after which they may be released to your account.</p>\
<p>All provisions of this Agreement that, by their nature, should survive termination, will remain in effect after termination. These provisions include, but are not limited to, ownership provisions, warranty disclaimers, and limitations of liability.</p>\

<h1>Indemnity:</h1>
                              <p>You agree to indemnify and hold the Company, its parents, subsidiaries, affiliates, officers, and employees harmless from any and all claims or demands made by third parties arising out of or related to your access to or use of the Services, your violation of this Agreement, or the infringement by you or anyone using your account of any intellectual property or other rights of any person or entity. This includes, without limitation, all damages, liabilities, settlements, costs, and attorneys' fees.</p>

                              <h1>Limitation of Liability:</h1>
                              <p>To the fullest extent permissible by law, and notwithstanding anything to the contrary in this Agreement, in no event shall either party, its affiliates, or any licensor or supplier of the Company be liable under or in connection with this Agreement for:</p>

                              <ol>
                              <li>Any consequential, indirect, special, incidental, or punitive damages;</li>
                              <li>Any loss of profits, business, revenue, anticipated savings, or wasted expenditure;</li>
                              <li>Any loss of or damage to data, networks, information systems, reputation, or goodwill; or</li>
                              <li>The cost of procuring substitute goods or services.</li>
                              </ol>

                              <p>To the maximum extent permitted by law, the combined aggregate liability of the Company and its affiliates under or in connection with this Agreement, the Software, and the Service shall not exceed the amount actually paid by you to the Company under this Agreement in the three (3) months preceding the date giving rise to the liability.</p>

                              <p>These exclusions and limitations apply:</p>

                              <ol>
                              <li>to the maximum extent allowed by applicable law;</li>
                              <li>even if a party was advised or should have been aware of the possibility of such damages;</li>
                              <li>even if any remedy in this Agreement fails of its essential purpose; and</li>
                              <li>regardless of the theory or basis of liability, including but not limited to contract, tort (including negligence or breach of statutory duty), misrepresentation, restitution, or otherwise.</li>
                              </ol>

                              <h2>Disclaimer:</h2>
                              <p>To the maximum extent permitted by law, you acknowledge that the Service, the Company Content, and any related goods or services provided (collectively, the Company Materials) are provided on an as is and as available basis, with all faults and without any warranties, guarantees, or conditions of any kind. This includes but is not limited to express, implied, or statutory warranties or conditions such as merchantability, satisfactory quality, fitness for a particular purpose, non-infringement, title, or reliability, all of which are disclaimed by the Company, its suppliers, and licensors.</p>

                              <p>To the maximum extent permitted by law, the Company and its licensors make no representations, warranties, or guarantees regarding:</p>

                              <ol>
                              <li>the effectiveness, reliability, completeness, timeliness, or quality of the Company Materials, the Services, or the Software;</li>
                              <li>uninterrupted, secure, or error-free use of the Company Materials, Services, or Software;</li>
                              <li>the operation of networks, data transmission, or connectivity issues; or</li>
                              <li>compliance with laws, regulations, or other standards.</li>
                              </ol>

                              <p>The Company does not warrant that the content available on or generated by the Software or Service is accurate, complete, or error-free, or that the Service or Software is free of viruses or harmful code. The Company reserves the right to make changes to the content, Software, and/or Services at any time without notice.</p>

                              <p>The Company will not be liable for delays, interruptions, service failures, or issues related to internet use, public networks, or hosting providers. You assume all risks and costs associated with using the Software or Service and agree that the Company is not responsible for any consequences, including technical problems such as slow connections, traffic congestion, or server overloads. Applicable law may not allow the exclusion of certain warranties. To the extent that such exclusions are not allowed, they may not apply to you.</p>

                              <h1>Governing Law:</h1>
                              <p>The laws of the Country, excluding its conflict of law rules, shall govern these Terms and your use of the Service. Your use of the Application may also be subject to local, state, national, or international laws.</p>

                              <h1>Disputes Resolution:</h1>
                              <p>If you have any concerns or disputes regarding the Service, you agree to first attempt to resolve the dispute informally by contacting the company.</p>

                              <p><b>For European Union (EU) Users:</b></p>
                              <p>If you are a European Union consumer, you will benefit from any mandatory provisions of the law of the country in which you reside.</p>

                              <p>United States Federal Government End Use Provisions:<br>
                              If you are a U.S. federal government end user, our Service is classified as a Commercial Item, as defined in 48 C.F.R. §2.101.</p>

                              <p>United States Legal Compliance:</p>
                              <p>You represent and warrant that:</p>

                              <ol>
                              <li>You are not located in a country subject to a United States government embargo or designated by the United States government as a terrorist-supporting country; and</li>
                              <li>You are not listed on any United States government list of prohibited or restricted parties.</li>
                              </ol>

                              <h1>Severability and Waiver:</h1>


                              <h2>Severability:</h2>
                              <p>If any provision of these Terms is found to be unenforceable or invalid, such provision will be modified and interpreted to accomplish its objectives to the greatest extent possible under applicable law, and the remaining provisions will remain in full force and effect.</p>

                              <h2>Waiver:</h2>
                              <p>Except as explicitly stated herein, the failure to exercise a right or enforce an obligation under these Terms shall not affect a party's ability to exercise such right or enforce such obligation at any time thereafter, nor shall a waiver of any breach constitute a waiver of any subsequent breach.</p>

                              <h2>Translation Interpretation:</h2>
                              <p>These Terms and Conditions may have been translated if made available to you in another language on our Service. In the event of a dispute, the original English version shall prevail.</p>


                              <h2>Changes to These Terms and Conditions:</h2>
                              <p>We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will make reasonable efforts to provide at least 30 days' notice before the new terms take effect. The determination of what constitutes a material change will be made at our sole discretion. By continuing to access or use our Service after the revisions become effective, you agree to be bound by the updated Terms. If you do not agree to the revised Terms, either in whole or in part, you must stop using the Service and website.</p>
                              <ul>
                                  <li><b>Contact Us</b>: If you have any questions about these Terms and Conditions, you can</li>
                                  <li>contact us at</li>
                                  <li><b>Website</b>: <a href=\"https://osllm.ai\" style=\"color: " + Style.Colors.textInformation + "; text-decoration:none;\">https://osllm.ai</a></li>
                                  <li><b>Email</b>: <a href=\"mailto:support@osllm.ai\" style=\"color: " + Style.Colors.textInformation + "; text-decoration:none;\">support@osllm.ai</a></li>
                              </ul>
<br>
<br>
<br>
"

            onLinkActivated: function(link) {
                Qt.openUrlExternally(link)
            }

            Accessible.role: Accessible.Button
            Accessible.name: text
            Accessible.description: qsTr("Select the current chat or edit the chat when in edit mode")
        }
    }
}














