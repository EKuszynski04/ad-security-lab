
**Windows AD Project**

# Purpose

The purpose of this project is to create a Windows AD environment that will simulate a real life scenario. This exercise will be used to get hands on experience of using and operating Windows AD. This will be achieved by designing and implementing a full scale solution to a simple problem that is grounded in reality. Documentation will be an essential part of this project and by the end a clean timeline of design and development will be laid out. All parts of this journey will be chronicled including all the thought processes and decision making behind each component. The goal of this project is to provide a working lab environment that demonstrates my ability of planning, preparing, designing, implementing and reviewing a Windows enterprise network.

# Scenario

A school needs a Windows AD environment designed and implemented for their school. The school consist of 1200 students and 150 staff. The school accommodates all age ranges of students and is a single campus school. The school needs a system that will sort the data of students (by year group), teaching staff, admin staff, IT staff, contractors (catering and cleaning) and temporary exam invigilators. The system will control access to sensitive data such as student records, safeguarding notes, exam papers, staff HR data and financial records. The system needs to record who accessed what and at what time example “we need to know who accessed exam papers and when" and "Ofsted requires evidence of access control." _The school's safeguarding lead and Ofsted preparation drove the decision to design a new AD environment with access control and full audit logging._

# Constraints

A table that showcases all the constraints that must be followed during the design and development of the program.

  

| Constraint | Reasoning |
| :--- | :--- |
| Budget | Open source only for SIEM. Windows Server free licence. |
| Timeline | 12 week deadline. |
| Skills | Solo project. Design must be simple enough to be maintained by a singular person. |
| Physical | Single site. Simulated using VMs. |
| Regulations | GDPR, Ofsted and safeguarding (KCSIE). |
  
  

# Scope

## Included

-   AD Forest and domain design
    
-   OU Structure, group model and delegation
    
-   GPO baseline
    
-   File server integration and share permissions
    
-   SIEM deployment and detection rules
    
-   Attack simulation
    

## Not Included

-   Azure AD/ Hybrid identity
    
-   Exchange
    
-   Backup implementation
    
-   Endpoint protection
    

# Success Criteria

This project will be considered a success if:

1.  A fully functional domain is operational with OU and group structure.
    
2.  Access to sensitive information is restricted based on role.
    
3.  The SIEM successfully processes Windows Security, Sysmon and PowerShell logs.
    
4.  At least 6 security detections are implemented.
    
5.  A simulated attack is detected by the SIEM.
    
6.  Full design, implementation and attack are documented.